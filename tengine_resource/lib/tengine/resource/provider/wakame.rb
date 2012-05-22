# -*- coding: utf-8 -*-
require 'tama'
require 'tengine/support/core_ext/hash/keys'
require 'tengine/support/core_ext/enumerable/map_to_hash'

class Tengine::Resource::Provider::Wakame < Tengine::Resource::Provider::Ec2

  attr_accessor :retry_on_error

  # field :connection_settings, :type => Hash # 継承元のTengine::Resource::Provider::Ec2で定義されているので不要

  PHYSICAL_SERVER_STATES = [:online, :offline].freeze

  VIRTUAL_SERVER_STATES = [
    :scheduling, :pending, :starting, :running,
    :failingover, :shuttingdown, :terminated].freeze

  def update_virtual_server_images
    connect do |conn|
      hashs = conn.describe_images.map do |hash|
        {
          :provided_id => hash.delete(:aws_id),
          :provided_description => hash.delete(:aws_description),
        }
      end
      update_virtual_server_images_by(hashs)
    end
  end

  # @param  [String]                                 name         Name template for created virtual servers
  # @param  [Tengine::Resource::VirtualServerImage]  image        virtual server image object
  # @param  [Tengine::Resource::VirtualServerType]   type         virtual server type object
  # @param  [Tengine::Resource::PhysicalServer]      physical     physical server object
  # @param  [String]                                 description  what this virtual server is
  # @param  [Numeric]                                count        number of vortial servers to boot
  # @return [Array<Tengine::Resource::VirtualServer>]
  def create_virtual_servers(name, image, type, physical, description = "", count = 1, &block)
    return super(
      name,
      image,
      type,
      physical.provided_id,
      description,
      count,  # min
      count,  # max
      [],     # grouop id
      self.properties['key_name'] || self.properties[:key_name],
      "",     # user data
      nil,    # kernel id
      nil,     # ramdisk id
      &block
    )
  end

  def terminate_virtual_servers(servers)
    connect do |conn|
      conn.terminate_instances(servers.map {|i| i.provided_id }).map do |hash|
        serv = self.virtual_servers.where(:provided_id => hash[:aws_instance_id]).first
        serv
      end
    end
  end

  def capacities
    server_type_ids = virtual_server_types.map(&:provided_id)
    server_type_to_cpu = virtual_server_types.map_to_hash(:provided_id, &:cpu_cores)
    server_type_to_mem = virtual_server_types.map_to_hash(:provided_id, &:memory_size)
    physical_servers.inject({}) do |result, physical_server|
      if physical_server.status == 'online'
        active_guests = physical_server.guest_servers.reject do |i|
          i.status.to_s == "terminated" or
            server_type_to_cpu[i.provided_type_id].nil? or
            server_type_to_mem[i.provided_type_id].nil?
        end
        cpu_free = physical_server.cpu_cores - active_guests.map{|s| server_type_to_cpu[s.provided_type_id]}.sum
        mem_free = physical_server.memory_size - active_guests.map{|s| server_type_to_mem[s.provided_type_id]}.sum
        result[physical_server.provided_id] = server_type_ids.map_to_hash do |server_type_id|
          [ cpu_free / server_type_to_cpu[server_type_id],
            mem_free / server_type_to_mem[server_type_id]
          ].min
        end
      else
        result[physical_server.provided_id] = server_type_ids.map_to_hash{|server_type_id| 0}
      end
      result
    end
  end

  def synchronize_physical_servers     ; synchronize_by(:physical_servers     ); end # 物理サーバの監視
  def synchronize_virtual_server_types ; synchronize_by(:virtual_server_types ); end # 仮想サーバタイプの監視
  def synchronize_virtual_server_images; synchronize_by(:virtual_server_images); end # 仮想サーバイメージの監視
  def synchronize_virtual_servers      ; synchronize_by(:virtual_servers      ); end # 仮想サーバの監視

  private

  PRIVATE_IP_ADDRESS = "private_ip_address".freeze

  WATCH_SETTINGS = {
    :physical_servers => {
      :api => :describe_host_nodes_for_api,
      :property_map => {
        :provided_id => :id,
        # wakame-adapters-tengine が name を返さない仕様の場合は、provided_id を name に登録します
        :name        => Proc.new{|hash| hash.delete(:name) || hash[:id]},
        :status      => :status,
        :cpu_cores   => :offering_cpu_cores,
        :memory_size => :offering_memory_size
      }
    }.freeze,

    :virtual_server_types => {
      :api => :describe_instance_specs_for_api,
      :property_map => {
        :provided_id => :id,
        :caption     => :uuid,
        :cpu_cores   => :cpu_cores,
        :memory_size => :memory_size
      }
    }.freeze,

    :virtual_server_images => {
      :api => :describe_images_for_api,
      :property_map => {
        :provided_id => :aws_id,
        :provided_description => :description
      },
      :before_create => Proc.new do |attrs|
        # 初期登録時、default 値として name には一意な provided_id を name へ登録します
        attrs[:name] = attrs[:provided_id]
      end

    }.freeze,

    :virtual_servers => {
      :api => :describe_instances_for_api,
      :property_map => {
        :provided_id       => :aws_instance_id,
        :provided_image_id => :aws_image_id,
        :provided_type_id  => :aws_instance_type,
        :status            => :aws_state,
        :host_server => Proc.new{|props, provider|
          provider.physical_servers.where(:provided_id => props[:aws_availability_zone]).first },
        :addresses => Proc.new do|props|
          result = { PRIVATE_IP_ADDRESS => props.delete(:private_ip_address) }
          props.delete(:ip_address).split(",").map do |i|
            k, v = *i.split("=", 2)
            result[k] = v
          end
          result
        end
      },

      :ignore_duplication_error => true, # 重複エラーは無視する

      :before_create => Proc.new do |attrs|
        # 初期登録時、default 値として name には一意な provided_id を name へ登録します
        attrs[:name] = attrs[:provided_id]
      end,

      :update_block => Proc.new do |virtual_server, properties|
        virtual_server.save! if virtual_server.changed? && !virtual_server.changes.values.all?{|v| v.nil?}
      end
    }.freeze,
  }.freeze

  def synchronize_by(target_name)
    Synchronizer.new(self, target_name).execute
  end

  class Synchronizer
    attr_reader :provider, :target_name
    def initialize(provider, target_name)
      @provider, @target_name = provider, target_name
    end

    def execute
      log_prefix = "#{self.class.name}#synchronize_by(#{target_name.inspect}) (provider:#{provider.name}):"
      setting = WATCH_SETTINGS[target_name]

      # APIからの仮想サーバタイプ情報を取得
      desc_api = setting[:api]
      actual_targets = provider.send(desc_api)
      Tengine.logger.debug "#{log_prefix} #{desc_api} for api (wakame)"
      Tengine.logger.debug "#{log_prefix} #{actual_targets.inspect}"

      # created_targets = []
      updated_targets = []
      destroyed_targets = []

      # 仮想イメージタイプの取得
      provider.reload
      known_targets = provider.send(target_name)
      Tengine.logger.debug "#{log_prefix} #{target_name} on provider (#{provider.name})"
      Tengine.logger.debug "#{log_prefix} #{known_targets.inspect}"

      id_key = WATCH_SETTINGS[target_name][:property_map][:provided_id].to_s

      known_targets.each do |known_target|
        actual_target = actual_targets.detect do |t|
          (t[id_key] || t[id_key.to_sym]) == known_target.provided_id
        end

        if actual_target
          # APIで取得したサーバタイプと一致するものがあれば更新対象
          Tengine.logger.debug "#{log_prefix} registed #{target_name.to_s.singularize} % <update> (#{known_target.provided_id})"
          updated_targets << actual_target
        else
          # APIで取得したサーバタイプと一致するものがなければ削除対象
          Tengine.logger.debug "#{log_prefix} removed #{target_name.to_s.singularize} % <destroy> (#{known_target.provided_id})"
          destroyed_targets << known_target
        end
      end
      # APIで取得したサーバタイプがTengine上に存在しないものであれば登録対象
      created_targets = actual_targets - updated_targets
      created_targets.each do |spec|
        Tengine.logger.debug "#{log_prefix} new #{target_name.to_s.singularize} % <create> (#{spec['id']})"
      end

      differential_update(updated_targets) unless updated_targets.empty?
      create_by_hashs(created_targets) unless created_targets.empty?
      destroyed_targets.each{ |target| target.destroy }
    end

    private

    def differential_update(hashs)
      hashs.map{|hash| differential_update_by_hash(hash)}
    end

    def differential_update_by_hash(hash, &block)
      properties = hash.dup
      properties.deep_symbolize_keys!
      setting = WATCH_SETTINGS[target_name]
      map = setting[:property_map]
      provided_id = properties[ map[:provided_id] ]
      target = provider.send(target_name).where(:provided_id => provided_id).first
      unless target
        raise "target #{target_name.to_s.singularize} not found by using #{map[:provided_id]}: #{provided_id.inspect}. properties: #{properties.inspect}"
      end
      attrs = mapped_attributes(properties)
      attrs.each do |attr, value|
        target.send("#{attr}=", value)
      end
      prop_backup = properties.dup
      if target.respond_to?(:properties)
        properties.each do |key, val|
          value =  properties.delete(key)
          unless val.to_s == value.to_s
            if target.properties[key.to_sym]
              target.properties[key.to_sym] = value
            else
              target.properties[key.to_s] = value
            end
          end
        end
      end
      block ||= setting[:update_block]
      if block
        block.call(target, prop_backup)
      else
        target.save! if target.changed?
      end
    end

    def create_by_hashs(hashs)
      hashs.map{|hash| t = create_by_hash(hash); t ? t.id : nil}.compact
    end

    def create_by_hash(hash)
      properties = hash.dup
      properties.deep_symbolize_keys!
      setting = WATCH_SETTINGS[target_name]
      begin
        map = setting[:property_map]
        attrs = mapped_attributes(properties)
        if before_create = setting[:before_create]
          before_create.call(attrs)
        end
        target = provider.send(target_name).new
        attrs[:properties] = properties if target.respond_to?(:properties)
        yield(attrs) if block_given?
        target.attributes = attrs
        target.save!
        target
      rescue Mongo::OperationFailure => e
        raise e if setting[:ignore_duplication_error] && e.message !~ /E11000 duplicate key error/
        nil
      rescue Mongoid::Errors::Validations => e
        raise e if setting[:ignore_duplication_error] && e.document.errors[:provided_id].any?{|s| s =~ /taken/}
        nil
      end
    end

    def mapped_attributes(properties)
      result = {}
      setting = WATCH_SETTINGS[target_name]
      map = setting[:property_map]
      map.each do |attr, prop|
        value = prop.is_a?(Proc) ?
        prop.call(properties, provider) : # 引数を一つだけ使うこともあるのlambdaではなくProc.newを使う事を期待しています。
          properties.delete(prop)
        result[attr] = value
      end
      result
    end

  end


  public

  # wakame api for tama
  def describe_instance_specs_for_api(uuids = [], options = {})
    call_api_with_conversion(:describe_instance_specs, uuids, options)
  end

  def describe_host_nodes_for_api(uuids = [], options = {})
    call_api_with_conversion(:describe_host_nodes, uuids, options)
  end

  def describe_instances_for_api(uuids = [], options = {})
    result = call_api_with_conversion(:describe_instances, uuids, options)
    result.each do |r|
      replace_value_of_hash(r, :private_ip_address) do |v|
        v.first if v.is_a?(Array)
      end
      replace_value_of_hash(r, :ip_address) do |v|
        "nw-data\=#{$1}" if (v =~ /^nw\-data\=\[\"(.+)\"\]$/)
      end
    end
    result
  end

  def describe_images_for_api(uuids = [], options = {})
    call_api_with_conversion(:describe_images, uuids, options)
  end

  def run_instances_for_api(uuids = [], options = {})
    call_api_with_conversion(:run_instances, uuids, options)
  end

  def terminate_instances_for_api(uuids = [], options = {})
    call_api_with_conversion(:terminate_instances, uuids, options)
  end

  private

  # wakame api からの戻り値がのキーが文字列だったりシンボルだったりで統一されてないので暫定対応で
  # 戻り値の配列の要素となるHashのkeyをstringかsymbolかのどちらかに指定できるようにしています
  def call_api_with_conversion(api_name, uuids, options)
    result = connect{|conn| conn.send(api_name, uuids) }
    case options[:convert]
    when :string then result.map(&:deep_stringify_keys!)
    when :symbol then result.map(&:deep_symbolize_keys!)
    else result
    end
  end

  def replace_value_of_hash(hash, key)
    [key, key.to_s].each do |k|
      if value = hash[k]
        if result = yield(value)
          hash[k] = result
          return
        end
      end
    end
  end


  public

  def connect(&block)
    send(retry_on_error ? :connect_with_retry : :connect_without_retry, &block)
  end

  CONNECTION_TEST_ATTRIBUTES = [:describe_instances_file, :describe_images_file, :run_instances_file,
    :terminate_instances_file, :describe_host_nodes_file, :describe_instance_specs_file].freeze

  def connect_without_retry
    connection = nil
    if self.connection_settings[:test] || self.connection_settings["test"]
      # テスト用
      connection = ::Tama::Controllers::ControllerFactory.create_controller(:test)
      options = self.connection_settings[:options] || self.connection_settings["options"]
      if options
        options.symbolize_keys!
        CONNECTION_TEST_ATTRIBUTES.each do |key|
          connection.send("#{key}=", File.expand_path(options[key])) if options[key]
        end
      end
    else
      options = self.connection_settings.symbolize_keys
      args = [:account, :ec2_host, :ec2_port, :ec2_protocol, :wakame_host, :wakame_port, :wakame_protocol].map{|key| options[key]}
      connection = ::Tama::Controllers::ControllerFactory.create_controller(*args)
    end
    return yield(connection)
  end

  def connect_with_retry(&block)
    retry_count = 1
    begin
      return connect_without_retry(&block)
    rescue Exception => e
      if retry_count > self.retry_count
        Tengine.logger.error "#{e.class.name} #{e.message}"
        raise e
      else
        Tengine.logger.warn "retry[#{retry_count}]: #{e.message}"
        sleep self.retry_interval
        retry_count += 1
        retry
      end
    end
  end

  private

  def address_order
    @@address_order ||= ['private_ip_address'.freeze].freeze
  end

end
