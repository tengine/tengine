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

  def synchronize_by(target_name)
    synchronizer = synchronizers_by(target_name)
    synchronizer.execute
  end

  def synchronizers_by(target_name)
    unless @synchronizers
      @synchronizers = {}
      SYNCHRONIZER_CLASSES.each do |target_name, klass|
        @synchronizers[target_name] = klass.new(self, target_name)
      end
    end
    @synchronizers[target_name]
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

  public

  class Synchronizer < Tengine::Resource::Provider::Synchronizer
  end

  class PhysicalServerSynchronizer < Synchronizer
    fetch_known_target_method :describe_host_nodes_for_api

    map(:provided_id, :id)
    # wakame-adapters-tengine が name を返さない仕様の場合は、provided_id を name に登録します
    map(:name){|hash, _| hash.delete(:name) || hash[:id]}
    map(:status     , :status)
    map(:cpu_cores  , :offering_cpu_cores)
    map(:memory_size, :offering_memory_size)
  end

  class VirtualServerTypeSynchronizer < Synchronizer
    fetch_known_target_method :describe_instance_specs_for_api

    map :provided_id, :id
    map :caption    , :uuid
    map :cpu_cores  , :cpu_cores
    map :memory_size, :memory_size
  end

  class VirtualServerImageSynchronizer < Synchronizer
    fetch_known_target_method :describe_images_for_api

    map :provided_id         , :aws_id
    map :provided_description, :description

    def attrs_to_create(properties)
      result = super(properties)
      # 初期登録時、default 値として name には一意な provided_id を name へ登録します
      result[:name] = result[:provided_id]
      result
    end
  end

  class VirtualServerSynchronizer < Synchronizer
    fetch_known_target_method :describe_instances_for_api

    PRIVATE_IP_ADDRESS = "private_ip_address".freeze

    map(:provided_id      , :aws_instance_id)
    map(:provided_image_id, :aws_image_id)
    map(:provided_type_id , :aws_instance_type)
    map(:status           , :aws_state)
    map(:host_server) do |props, provider|
      provider.physical_servers.where(:provided_id => props[:aws_availability_zone]).first
    end
    map(:addresses) do|props, _|
      result = { PRIVATE_IP_ADDRESS => props.delete(:private_ip_address) }
      props.delete(:ip_address).split(",").map do |i|
        k, v = *i.split("=", 2)
        result[k] = v
      end
      result
    end

    def create_by_hash(hash)
      super(hash)
    rescue Mongo::OperationFailure => e
      raise e unless e.message =~ /E11000 duplicate key error/
      nil
    rescue Mongoid::Errors::Validations => e
      raise e unless e.document.errors[:provided_id].any?{|s| s =~ /taken/}
      nil
    end

    def attrs_to_create(properties)
      result = super(properties)
      # 初期登録時、default 値として name には一意な provided_id を name へ登録します
      result[:name] = result[:provided_id]
      result
    end

    def differential_update_by_hash(hash)
      super(hash) do |virtual_server, properties|
        virtual_server.save! if virtual_server.changed? && !virtual_server.changes.values.all?{|v| v.nil?}
      end
    end
  end

  SYNCHRONIZER_CLASSES = {
    :physical_servers      => PhysicalServerSynchronizer,
    :virtual_server_types  => VirtualServerTypeSynchronizer,
    :virtual_server_images => VirtualServerImageSynchronizer,
    :virtual_servers       => VirtualServerSynchronizer,
  }.freeze

end
