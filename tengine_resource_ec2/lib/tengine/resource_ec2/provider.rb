# -*- coding: utf-8 -*-
require 'tengine/resource_ec2'

require 'right_aws'

class Tengine::ResourceEc2::Provider < Tengine::Resource::Provider

  field :connection_settings, :type => Hash

  def synchronize_physical_servers
    synchronize_by(:physical_servers)
  end

  def synchronize_virtual_server_images
    synchronize_by(:virtual_server_images)
  end

  def synchronize_virtual_servers
    synchronize_by(:virtual_servers)
  end



  class Synchronizer < Tengine::Resource::Provider::Synchronizer
  end

  class PhysicalServerSynchronizer < Synchronizer
    fetch_known_target_method :describe_availability_zones

    map(:provided_id, :zone_name)
    map(:status     , :zone_status)
    map(:cpu_cores  ) { 1000 }
    map(:memory_size) { 1000 }

    def attrs_to_create(properties)
      result = super(properties)
      # 初期登録時、default 値として name には一意な provided_id を name へ登録します
      result[:name] = result[:provided_id]
      result
    end
  end

  class VirtualServerImageSynchronizer < Synchronizer
    fetch_known_target_method :describe_images
    map :provided_id         , :aws_id

    def attrs_to_create(properties)
      result = super(properties)
      # 初期登録時、default 値として name には一意な provided_id を name へ登録します
      result[:name] = result[:provided_id]
      result
    end
  end

  class VirtualServerSynchronizer < Synchronizer
    fetch_known_target_method :describe_instances

    map :provided_id      , :aws_instance_id
    map :provided_image_id, :aws_image_id
    map :status           , :aws_state
    map(:host_server) do |props, provider|
      provider.physical_servers.where(:provided_id => props[:aws_availability_zone]).first
    end
    map :addresses do |props, provider|
      {
        :dns_name           => props.delete(:dns_name          ),
        :ip_address         => props.delete(:ip_address        ),
        :private_dns_name   => props.delete(:private_dns_name  ),
        :private_ip_address => props.delete(:private_ip_address),
      }
    end

    def attrs_to_create(properties)
      result = super(properties)
      result[:name] = result[:provided_id]
      result
    end
  end

  def describe_availability_zones
      # ec2.describe_availability_zones  #=> [{:region_name=>"us-east-1",
      #                                        :zone_name=>"us-east-1a",
      #                                        :zone_state=>"available"}, ... ]
      # http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/index.html?ApiReference-query-DescribeAvailabilityZones.html
    connect{|conn| conn.describe_availability_zones }
  end

  def describe_images
    connect{|conn| conn.describe_images_by_owner("self")}
  end

  def describe_instances
      # http://rightscale.rubyforge.org/right_aws_gem_doc/
      # ec2.describe_instances #=>
      #   [{:aws_image_id       => "ami-e444444d",
      #     :aws_reason         => "",
      #     :aws_state_code     => "16",
      #     :aws_owner          => "000000000888",
      #     :aws_instance_id    => "i-123f1234",
      #     :aws_reservation_id => "r-aabbccdd",
      #     :aws_state          => "running",
      #     :dns_name           => "domU-12-34-67-89-01-C9.usma2.compute.amazonaws.com",
      #     :ssh_key_name       => "staging",
      #     :aws_groups         => ["default"],
      #     :private_dns_name   => "domU-12-34-67-89-01-C9.usma2.compute.amazonaws.com",
      #     :aws_instance_type  => "m1.small",
      #     :aws_launch_time    => "2008-1-1T00:00:00.000Z"},
      #     :aws_availability_zone => "us-east-1b",
      #     :aws_kernel_id      => "aki-ba3adfd3",
      #     :aws_ramdisk_id     => "ari-badbad00",
      #      ..., {...}]
      # http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/index.html?ApiReference-query-DescribeInstances.html
    connect{|conn| conn.describe_instances }
  end







  register_synchronizers({
    :physical_servers      => PhysicalServerSynchronizer,
    # :virtual_server_types  => VirtualServerTypeSynchronizer,
    :virtual_server_images => VirtualServerImageSynchronizer,
    :virtual_servers       => VirtualServerSynchronizer,
  })

  private
  def update_physical_servers_by(hashs)
    found_ids = []
    hashs.each do |hash|
      server = self.physical_servers.where(:provided_id => hash[:provided_id]).first
      if server
        server.update_attributes(:status => hash[:status])
      else
        server = self.physical_servers.create!(
          :provided_id => hash[:provided_id],
          :name => hash[:name],
          :status => hash[:status])
      end
      found_ids << server.id
    end
    self.physical_servers.not_in(:_id => found_ids).update_all(:status => "not_found")
  end

  def update_virtual_servers_by(hashs)
    found_ids = []
    hashs.each do |hash|
      server = self.virtual_servers.where(:provided_id => hash[:provided_id]).first
      if server
        server.update_attributes(hash)
      else
        server = self.virtual_servers.create!(hash.merge(:name => hash[:provided_id]))
      end
      found_ids << server.id
    end
    self.virtual_servers.not_in(:_id => found_ids).destroy_all
  end

  def update_virtual_server_images_by(hashs)
    found_ids = []
    hashs.each do |hash|
      img = self.virtual_server_images.where(:provided_id => hash[:provided_id]).first
      if img
        img.update_attributes(hash)
      else
        img = self.virtual_server_images.create!(hash.merge(:name => hash[:provided_id]))
      end
      found_ids << img.id
    end
    self.virtual_server_images.not_in(:_id => found_ids).destroy_all
  end


  public

  # @param  [String]                                 name         Name template for created virtual servers
  # @param  [Tengine::Resource::VirtualServerImage]  image        Virtual server image object
  # @param  [Tengine::Resource::VirtualServerType]   type         Virtual server type object
  # @param  [String]                                 physical     Data center name to put virtual machines (availability zone)
  # @param  [String]                                 description  What this virtual server is
  # @param  [Numeric]                                min_count    Minimum number of vortial servers to boot
  # @param  [Numeric]                                max_count    Maximum number of vortial servers to boot
  # @param  [Array<Strng>]                           group_ids    Array of names of security group IDs
  # @param  [Strng]                                  key_name     Name of root key to sue
  # @param  [Strng]                                  user_data    User-specified
  # @param  [Strng]                                  kernel_id    Kernel image ID
  # @param  [Strng]                                  ramdisk_id   Ramdisk image ID
  # @return [Array<Tengine::Resource::VirtualServer>]
  def create_virtual_servers name, image, type, physical, description, min_count, max_count, group_ids, key_name, user_data = "", kernel_id, ramdisk_id
    connect {|conn|
      results = conn.run_instances(
        image.provided_id,
        min_count,
        max_count,
        group_ids,
        key_name,
        user_data,
        nil, # <- addressing_type
        type.provided_id,
        kernel_id,
        ramdisk_id,
        physical,
        nil  # <- block_device_mappings
      )
      yield if block_given? # テスト用のブロックの呼び出し
      results.map.with_index {|hash, idx|
        provided_id = hash.delete(:aws_instance_id)
        if server = self.virtual_servers.find(:first, :conditions => {:provided_id => provided_id})
          server
        else
          # findではなくfirstで検索しているので、もしhost_server_provided_idで指定されるサーバが見つからなくても
          # host_serverがnilとして扱われるが、仮想サーバ自身の登録は行われます
          host_server = Tengine::Resource::PhysicalServer.by_provided_id(
            [hash[:aws_availability_zone], physical].detect{|i| !i.blank?})
          self.find_virtual_server_on_duplicaion_error(provided_id) do
            self.virtual_servers.create!(
              :name                 => sprintf("%s%03d", name, idx + 1), # 1 origin
              :address_order        => address_order,
              :description          => description,
              :provided_id          => provided_id,
              :provided_image_id    => hash.delete(:aws_image_id),
              :provided_type_id     => hash.delete(:aws_instance_type),
              :host_server_id       => host_server ? host_server.id : nil,
              :status               => hash.delete(:aws_state),
              :properties           => hash,
              :addresses            => {
    #             :dns_name           => hash.delete(:dns_name),
    #             :ip_address         => hash.delete(:ip_address),
    #             :private_dns_name   => hash.delete(:private_dns_name),
    #             :private_ip_address => hash.delete(:private_ip_address),
              })
          end
        end
      }
    }
  end

  def terminate_virtual_servers servers
    connect do |conn|
      # http://rightscale.rubyforge.org/right_aws_gem_doc/classes/RightAws/Ec2.html#M000287
      # http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-TerminateInstances.html
      conn.terminate_instances(servers.map {|i| i.provided_id }).map do |hash|
        serv = self.virtual_servers.where(:provided_id => hash[:aws_instance_id]).first
        serv.update_attributes(:status => hash[:aws_current_state_name]) if serv
        serv
      end
    end
  end

  # 仮想サーバタイプの監視
  def synchronize_virtual_server_types
    # ec2から取得する情報はありません
  end

  private
  def address_order
    @@address_order ||= %w"private_ip_address private_dns_name ip_address dns_name".each(&:freeze).freeze
  end

  def connect
    klass = (ENV['EC2_DUMMY'] == "true") ? Tengine::ResourceEc2::DummyConnection : RightAws::Ec2
    connection_settings.stringify_keys! # DBに保存されるとSymbolのキーはStringに変換される
    Tengine.logger.info("now connecting by using #{connection_settings.inspect}")
    connection = klass.new(
      access_key,
      secret_access_key,
      {
        :logger => Tengine.logger,
        :region => connection_settings['region']
      }
      )
    yield connection
  end

  def access_key
    connection_settings['access_key'] || read_file_if_exist(connection_settings['access_key_file'])
  end

  def secret_access_key
    connection_settings['secret_access_key'] || read_file_if_exist(connection_settings['secret_access_key_file'])
  end

  def read_file_if_exist(filepath)
    return nil unless filepath
    File.read(File.expand_path(filepath)).strip # ~をホームディレクトリに展開するためにFile.expand_pathを使っています
  end

end
