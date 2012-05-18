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

  def terminate_virtual_servers servers
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


  # 仮想サーバタイプの監視
  def virtual_server_type_watch
    log_prefix = "#{self.class.name}#virtual_server_type_watch (provider:#{self.name}):"

    # APIからの仮想サーバタイプ情報を取得
    instance_specs = describe_instance_specs_for_api
    Tengine.logger.debug "#{log_prefix} describe_instance_specs for api (wakame)"
    Tengine.logger.debug "#{log_prefix} #{instance_specs.inspect}"

    create_instance_specs = []
    update_instance_specs = []
    destroy_server_types = []

    # 仮想イメージタイプの取得
    self.reload
    old_server_types = self.virtual_server_types
    Tengine.logger.debug "#{log_prefix} virtual_server_types on provider (#{self.name})"
    Tengine.logger.debug "#{log_prefix} #{old_server_types.inspect}"

    old_server_types.each do |old_server_type|
      instance_spec = instance_specs.detect do |instance_spec|
        (instance_spec[:id] || instance_spec["id"]) == old_server_type.provided_id
      end

      if instance_spec
        # APIで取得したサーバタイプと一致するものがあれば更新対象
        Tengine.logger.debug "#{log_prefix} registed virtual_server_type % <update> (#{old_server_type.provided_id})"
        update_instance_specs << instance_spec
      else
        # APIで取得したサーバタイプと一致するものがなければ削除対象
        Tengine.logger.debug "#{log_prefix} removed virtual_server_type % <destroy> (#{old_server_type.provided_id})"
        destroy_server_types << old_server_type
      end
    end
    # APIで取得したサーバタイプがTengine上に存在しないものであれば登録対象
    create_instance_specs = instance_specs - update_instance_specs
    create_instance_specs.each do |spec|
      Tengine.logger.debug "#{log_prefix} new virtual_server_type % <create> (#{spec['id']})"
    end

    # 更新
    self.differential_update_virtual_server_type_hashs(update_instance_specs) unless update_instance_specs.empty?
    # 登録
    self.create_virtual_server_type_hashs(create_instance_specs) unless create_instance_specs.empty?
    # 削除
    destroy_server_types.each { |target| target.destroy }
  end

  # 物理サーバの監視
  def physical_server_watch
    log_prefix = "#{self.class.name}#physical_server_watch (provider:#{self.name}):"

    # APIからの物理サーバ情報を取得
    host_nodes = describe_host_nodes_for_api
    Tengine.logger.debug "#{log_prefix} describe_host_nodes for api (wakame)"
    Tengine.logger.debug "#{log_prefix} #{host_nodes.inspect}"

    create_host_nodes = []
    update_host_nodes = []
    destroy_servers = []

    # 物理サーバの取得
    self.reload
    old_servers = self.physical_servers
    Tengine.logger.debug "#{log_prefix} physical_server on provider (#{self.name})"
    Tengine.logger.debug "#{log_prefix} #{old_servers.inspect}"

    old_servers.each do |old_server|
      host_node = host_nodes.detect do |host_node|
        (host_node[:id] || host_node["id"]) == old_server.provided_id
      end

      if host_node
        Tengine.logger.debug "#{log_prefix} registed physical_server % <update> (#{old_server.provided_id})"
        update_host_nodes << host_node
      else
        Tengine.logger.debug "#{log_prefix} removed physical_server % <destroy> (#{old_server.provided_id})"
        destroy_servers << old_server
      end
    end
    create_host_nodes = host_nodes - update_host_nodes
    create_host_nodes.each do |host_node|
      Tengine.logger.debug "#{log_prefix} new physical_server% <create> (#{host_node['id']})"
    end

    self.differential_update_physical_server_hashs(update_host_nodes) unless update_host_nodes.empty?
    self.create_physical_server_hashs(create_host_nodes) unless create_host_nodes.empty?
    destroy_servers.each { |target| target.destroy }
  end

  # 仮想サーバの監視
  def virtual_server_watch
    log_prefix = "#{self.class.name}#virtual_server_watch (provider:#{self.name}):"

    # APIからの仮想サーバ情報を取得
    instances = describe_instances_for_api
    Tengine.logger.debug "#{log_prefix} describe_instances for api (wakame)"
    Tengine.logger.debug "#{log_prefix} #{instances.inspect}"

    Tengine.logger.debug "#{log_prefix} virtual_servers on provider (#{self.name})"
    create_instances, update_instances, destroy_servers = partion_instances(instances)
    create_instances.each do |instance|
      Tengine.logger.debug "#{log_prefix} new virtual_server % <create> (#{instance[:aws_instance_id]})"
    end

    self.differential_update_virtual_server_hashs(update_instances) unless update_instances.empty?
    self.create_virtual_server_hashs(create_instances) unless create_instances.empty?
    destroy_servers.each { |target| target.destroy }
  end

  private

  def partion_instances(instances)
    log_prefix = "#{self.class.name}#virtual_server_watch (provider:#{self.name}):"
    create_instances, update_instances, destroy_servers = [], [], []
    self.reload
    old_servers = self.virtual_servers
    Tengine.logger.debug "#{log_prefix} #{old_servers.inspect}"
    old_servers.each do |old_server|
      instance = instances.detect do |instance|
        (instance[:aws_instance_id] || instance["aws_instance_id"]) == old_server.provided_id
      end
      if instance
        Tengine.logger.debug "#{log_prefix} registed virtual_server % <update> (#{old_server.provided_id})"
        update_instances << instance
      else
        Tengine.logger.debug "#{log_prefix} removed virtual_server % <destroy> (#{old_server.provided_id})"
        destroy_servers << old_server
      end
    end
    create_instances = instances - update_instances
    return create_instances, update_instances, destroy_servers
  end


  public

  # 仮想サーバイメージの監視
  def virtual_server_image_watch
    log_prefix = "#{self.class.name}#virtual_server_image_watch (provider:#{self.name}):"

    # APIからの仮想サーバイメージ情報を取得
    images = describe_images_for_api
    Tengine.logger.debug "#{log_prefix} describe_images for api (wakame)"
    Tengine.logger.debug "#{log_prefix} #{images.inspect}"

    create_images = []
    update_images = []
    destroy_server_images = []

    # 仮想サーバイメージの取得
    self.reload
    old_images = self.virtual_server_images
    Tengine.logger.debug "#{log_prefix} virtual_server_images on provider (#{self.name})"
    Tengine.logger.debug "#{log_prefix} #{old_images.inspect}"

    old_images.each do |old_image|
      image = images.detect do |image|
        (image[:aws_id] || image["aws_id"]) == old_image.provided_id
      end

      if image
        Tengine.logger.debug "#{log_prefix} registed virtualserver_image % <update> (#{old_image.provided_id})"
        update_images << image
      else
        Tengine.logger.debug "#{log_prefix} removed virtual_server_image % <destroy> (#{old_image.provided_id})"
        destroy_server_images << old_image
      end
    end
    create_images = images - update_images
    create_images.each do |image|
      Tengine.logger.debug "#{log_prefix} new server_image % <create> (#{image[:aws_id]})"
    end

    self.differential_update_virtual_server_image_hashs(update_images) unless update_images.empty?
    self.create_virtual_server_image_hashs(create_images) unless create_images.empty?
    destroy_server_images.each { |target| target.destroy }
  end

  # virtual_server_type
  def differential_update_virtual_server_type_hash(hash)
    properties = hash.dup
    properties.deep_symbolize_keys!
    virtual_server_type = self.virtual_server_types.where(:provided_id => properties[:id]).first
    virtual_server_type.provided_id = properties.delete(:id)
    virtual_server_type.caption = properties.delete(:uuid)
    virtual_server_type.cpu_cores = properties.delete(:cpu_cores)
    virtual_server_type.memory_size = properties.delete(:memory_size)
    properties.each do |key, val|
      value =  properties.delete(key)
      unless val.to_s == value.to_s
        if virtual_server_type.properties[key.to_sym]
          virtual_server_type.properties[key.to_sym] = value
        else
          virtual_server_type.properties[key.to_s] = value
        end
      end
    end
    virtual_server_type.save! if virtual_server_type.changed?
  end

  def differential_update_virtual_server_type_hashs(hashs)
    updated_server_types = []
    hashs.each do |hash|
      server_type = differential_update_virtual_server_type_hash(hash)
      updated_server_types << server_type
    end
    updated_server_types
  end

  def create_virtual_server_type_hash(hash)
    properties = hash.dup
    properties.deep_symbolize_keys!
    self.virtual_server_types.create!(
      :provided_id => properties.delete(:id),
      :caption => properties.delete(:uuid),
      :cpu_cores => properties.delete(:cpu_cores),
      :memory_size => properties.delete(:memory_size),
      :properties => properties)
  end

  def create_virtual_server_type_hashs(hashs)
    created_ids = []
    hashs.each do |hash|
      server_type = create_virtual_server_type_hash(hash)
      created_ids << server_type.id
    end
    created_ids
  end

  # physical_server
  def differential_update_physical_server_hash(hash)
    properties = hash.dup
    properties.deep_symbolize_keys!
    physical_server = self.physical_servers.where(:provided_id => properties[:id]).first
    # wakame-adapters-tengine が name を返さない仕様の場合は、provided_id を name に登録します
    physical_server.name = properties.delete(:name) || properties[:id]
    physical_server.provided_id = properties.delete(:id)
    physical_server.status = properties.delete(:status)
    physical_server.cpu_cores = properties.delete(:offering_cpu_cores)
    physical_server.memory_size = properties.delete(:offering_memory_size)
    properties.each do |key, val|
      value =  properties.delete(key)
      unless val.to_s == value.to_s
        if physical_server.properties[key.to_sym]
          physical_server.properties[key.to_sym] = value
        else
          physical_server.properties[key.to_s] = value
        end
      end
    end
    physical_server.save! if physical_server.changed?
  end

  def differential_update_physical_server_hashs(hashs)
    updated_servers = []
    hashs.each do |hash|
      server = differential_update_physical_server_hash(hash)
      updated_servers << server
    end
    updated_servers
  end

  def create_physical_server_hash(hash)
    properties = hash.dup
    properties.deep_symbolize_keys!
    self.physical_servers.create!(
      # wakame-adapters-tengine が name を返さない仕様の場合は、provided_id を name に登録します
      :name => properties.delete(:name) || properties[:id],
      :provided_id => properties.delete(:id),
      :status => properties.delete(:status),
      :cpu_cores => properties.delete(:offering_cpu_cores),
      :memory_size => properties.delete(:offering_memory_size),
      :properties => properties)
  end

  def create_physical_server_hashs(hashs)
    created_ids = []
    hashs.each do |hash|
      server = create_physical_server_hash(hash)
      created_ids << server.id
    end
    created_ids
  end

  # virtual_server_image
  def differential_update_virtual_server_image_hash(hash)
    properties = hash.dup
    properties.deep_symbolize_keys!
    server_image = self.virtual_server_images.where(:provided_id => properties[:aws_id]).first
    server_image.provided_id = properties.delete(:aws_id)
    server_image.provided_description = properties.delete(:description)
    server_image.save! if server_image.changed?
  end

  def differential_update_virtual_server_image_hashs(hashs)
    updated_images = []
    hashs.each do |hash|
      image = differential_update_virtual_server_image_hash(hash)
      updated_images << image
    end
    updated_images
  end

  def create_virtual_server_image_hash(hash)
    properties = hash.dup
    properties.deep_symbolize_keys!
    self.virtual_server_images.create!(
      # 初期登録時、default 値として name には一意な provided_id を name へ登録します
      :name => properties[:aws_id],
      :provided_id => properties.delete(:aws_id),
      :provided_description => properties.delete(:description))
  end

  def create_virtual_server_image_hashs(hashs)
    created_ids = []
    hashs.each do |hash|
      image = create_virtual_server_image_hash(hash)
      created_ids << image.id
    end
    created_ids
  end

  # virtual_server
  PRIVATE_IP_ADDRESS = "private_ip_address".freeze

  def differential_update_virtual_server_hash(hash)
    properties = hash.dup
    properties.deep_symbolize_keys!
    host_server = self.physical_servers.where(:provided_id => properties[:aws_availability_zone]).first
    virtual_server = self.virtual_servers.where(:provided_id => properties[:aws_instance_id]).first
    virtual_server.provided_id = properties.delete(:aws_instance_id)
    virtual_server.provided_image_id = properties.delete(:aws_image_id)
    virtual_server.provided_type_id = properties.delete(:aws_instance_type)
    virtual_server.status = properties.delete(:aws_state)
    virtual_server.host_server = host_server
    virtual_server.addresses[PRIVATE_IP_ADDRESS] = properties.delete(:private_ip_address)
    properties.delete(:ip_address).split(",").map do |i|
      k, v = i.split("=")
      virtual_server.addresses[k] = v
    end
    properties.each do |key, val|
      value =  properties.delete(key)
      unless val.to_s == value.to_s
        if virtual_server.properties[key.to_sym]
          virtual_server.properties[key.to_sym] = value
        else
          virtual_server.properties[key.to_s] = value
        end
      end
    end
    virtual_server.save! if virtual_server.changed? && !virtual_server.changes.values.all?{|v| v.nil?}
  end

  def differential_update_virtual_server_hashs(hashs)
    updated_servers = []
    hashs.each do |hash|
      server = differential_update_virtual_server_hash(hash)
      updated_servers << server
    end
    updated_servers
  end

  def create_virtual_server_hash(hash)
    properties = hash.dup
    properties.deep_symbolize_keys!
    host_server = self.physical_servers.where(:provided_id => properties[:aws_availability_zone]).first
    addresses = {PRIVATE_IP_ADDRESS => properties.delete(:private_ip_address)}
    properties.delete(:ip_address).split(",").map do |i|
      k, v = i.split("=")
      addresses[k] = v
    end
    self.virtual_servers.create!(
      # 初期登録時、default 値として name には一意な provided_id を name へ登録します
      :name => properties[:aws_instance_id],
      :provided_id => properties.delete(:aws_instance_id),
      :provided_image_id => properties.delete(:aws_image_id),
      :provided_type_id => properties.delete(:aws_instance_type),
      :status => properties.delete(:aws_state),
      :host_server => host_server,
      :addresses => addresses,
      :address_order => [PRIVATE_IP_ADDRESS],
      :properties => properties)
  rescue Mongo::OperationFailure => e
    raise e unless e.message =~ /E11000 duplicate key error/
  rescue Mongoid::Errors::Validations => e
    raise e unless e.document.errors[:provided_id].any?{|s| s =~ /taken/}
  end

  def create_virtual_server_hashs(hashs)
    created_ids = []
    hashs.each do |hash|
      if server = create_virtual_server_hash(hash)
        created_ids << server.id
      end
    end
    created_ids
  end

  # wakame api for tama

  # wakame api からの戻り値がのキーが文字列だったりシンボルだったりで統一されてないので暫定対応で
  # 戻り値のkeyをstringかsymbolかのどちらかに指定できるようにしています

  def hash_key_convert(hash_list, convert)
    case convert
    when :string then hash_list = hash_list.map(&:deep_stringify_keys!)
    when :symbol then hash_list = hash_list.map(&:deep_symbolize_keys!)
    end
    hash_list
  end

  def describe_instance_specs_for_api(uuids = [], option = {})
    result = connect do |conn|
      conn.describe_instance_specs(uuids)
    end
    hash_key_convert(result, option[:convert])
  end

  def describe_host_nodes_for_api(uuids = [], option = {})
    result = connect do |conn|
      conn.describe_host_nodes(uuids)
    end
    hash_key_convert(result, option[:convert])
  end

  def describe_instances_for_api(uuids = [], option = {})
    result = connect do |conn|
      conn.describe_instances(uuids)
    end
    result = hash_key_convert(result, option[:convert])
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

  private
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

  def describe_images_for_api(uuids = [], option = {})
    result = connect do |conn|
      conn.describe_images(uuids)
    end
    hash_key_convert(result, option[:convert])
  end

  def run_instances_for_api(uuids = [], option = {})
    result = connect do |conn|
      conn.run_instances(uuids)
    end
    hash_key_convert(result, option[:convert])
  end

  def terminate_instances_for_api(uuids = [], option = {})
    result = connect do |conn|
      conn.terminate_instances(uuids)
    end
    hash_key_convert(result, option[:convert])
  end

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
    yield connection
  end

  def connect_with_retry(&block)
    retry_count = 1
    begin
      connect_without_retry(&block)
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
