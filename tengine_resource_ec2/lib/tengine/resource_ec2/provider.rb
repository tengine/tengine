# -*- coding: utf-8 -*-
require 'tengine/resource_ec2'

require 'right_aws'

class Tengine::ResourceEc2::Provider < Tengine::Resource::Provider

  field :connection_settings, :type => Hash

  def synchronize_physical_servers
    connect do |conn|
      # ec2.describe_availability_zones  #=> [{:region_name=>"us-east-1",
      #                                        :zone_name=>"us-east-1a",
      #                                        :zone_state=>"available"}, ... ]
      # http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/index.html?ApiReference-query-DescribeAvailabilityZones.html
      hashs = conn.describe_availability_zones.map do |hash|
        {
          :provided_id => hash[:zone_name],
          :name    => hash[:zone_name],
          :status => hash[:zone_state],
        }
      end
      update_physical_servers_by(hashs)
    end
  end

  def synchronize_virtual_servers
    connect do |conn|
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
      hashs = conn.describe_instances.map do |hash|
        result = {
          :provided_id => hash.delete(:aws_instance_id),
          :provided_image_id => hash.delete(:aws_image_id),
          :status => hash.delete(:aws_state),
        }
        hash.delete(:aws_state_code)
        result[:properties] = hash
        result[:addresses] = {
          :dns_name        => hash.delete(:dns_name),
          :ip_address      => hash.delete(:ip_address),
          :private_dns_name => hash.delete(:private_dns_name),
          :private_ip_address => hash.delete(:private_ip_address),
        }
        result
      end
      update_virtual_servers_by(hashs)
    end
  end

  def synchronize_virtual_server_images
    connect do |conn|
      hashs = conn.describe_images.map do |hash|
        { :provided_id => hash.delete(:aws_id), }
      end
      update_virtual_server_images_by(hashs)
    end
  end

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
    klass = (ENV['EC2_DUMMY'] == "true") ? Tengine::Resource::Credential::Ec2::Dummy : RightAws::Ec2
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
    File.read(filepath).strip
  end

end
