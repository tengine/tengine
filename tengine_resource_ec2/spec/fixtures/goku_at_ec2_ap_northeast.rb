# -*- coding: utf-8 -*-

class GokuAtEc2ApNortheast
  # # memoize については http://wota.jp/ac/?date=20081025#p11 などを参照してください
  # extend ActiveSupport::Memoizable

  def provider
    Tengine::Resource::Provider::Ec2.find_or_create_by_name!({
        :name => "goku_at_ec2_ap-northeast-1",
        :connection_settings => {
          :access_key => '12345',
          :secret_access_key => '1234567',
          :default_region => 'ap-northeast-1',
        }
      })
  end

  def goku_ssh_pw
    Tengine::Resource::Credential.find_or_create_by_name!(
      :name => "goku_ssh_pw",
      :auth_type_key => :ssh_password,
      :auth_values => {
        :username => 'goku',
        :password => 'dragonball'
      })
  end

  def gohan_ssh_pk
    Tengine::Resource::Credential.find_or_create_by_name!(
      :name => "gohan_ssh_pk",
      :auth_type_key => :ssh_public_key,
      :auth_values => {
        :username => 'gohan',
        :private_keys => "1234567890",
        :passphrase => 'dragonball'
      })
  end

  def physical_servers
    [availability_zone(1), availability_zone(2)]
  end

  def availability_zone(idx)
    name = "ap-notrheast-1" + ("a".ord - 1 + idx).chr
    Tengine::Resource::PhysicalServer.find_or_create_by_name!(
      :provider_id => provider.id,
      :name => name, :provided_id => name, :status => "available")
  end

  def virtual_server_images
    [
      hadoop_image,
      mysql_image,
      rails_image
    ]
  end

  def hadoop_image
    Tengine::Resource::VirtualServerImage.find_or_create_by_name!(
      :provider_id => provider.id,
      :name => "hadoop_image1",
      :provided_id => "ami-10000001")
  end

  def mysql_image
    Tengine::Resource::VirtualServerImage.find_or_create_by_name!(
      :provider_id => provider.id,
      :name => "mysql_image1",
      :provided_id => "ami-10000002")
  end

  def rails_image
    Tengine::Resource::VirtualServerImage.find_or_create_by_name!(
      :provider_id => provider.id,
      :name => "rails_image1",
      :provided_id => "ami-10000003")
  end

  def virtual_server_types
    [
      m1_small,
      m1_large,
      m1_xlarge,
      t1_micro,
    ]
  end

  def m1_small
    Tengine::Resource::VirtualServerType.find_or_create_by(:provider_id => provider.id,
      :caption => "m1.small", :provided_id => "m1.small", :cpu_cores => 1, :memory_size => 17 * (10 ** 8))
  end

  def m1_large
    Tengine::Resource::VirtualServerType.find_or_create_by(:provider_id => provider.id,
      :caption => "m1.large", :provided_id => "m1.large", :cpu_cores => 4, :memory_size => 75 * (10 ** 8))
  end

  def m1_xlarge
    Tengine::Resource::VirtualServerType.find_or_create_by(:provider_id => provider.id,
      :caption => "m1.xlarge", :provided_id => "m1.xlarge", :cpu_cores => 8, :memory_size => 15 * (10 ** 9))
  end

  def t1_micro
    Tengine::Resource::VirtualServerType.find_or_create_by(:provider_id => provider.id,
      :caption => "t1.micro", :provided_id => "t1.micro", :cpu_cores => 2, :memory_size => 613 * (10 ** 6))
  end


  def virtual_servers
    [
      hadoop_master_node,
      hadoop_slave_node(1),
      hadoop_slave_node(2),
      hadoop_slave_node(3),
      mysql_master,
      mysql_slave(1),
      mysql_slave(2),
      rails_server(1)
    ]
  end

  def hadoop_master_node
    Tengine::Resource::VirtualServer.find_or_create_by_name!(
      :addresses => hostnames_and_ips(1),
      :provider_id => provider.id,
      :provided_image_id => hadoop_image.provided_id,
      :host_server_id => availability_zone(1).id, :status => "available",
      :name => "hadoop_master_node", :provided_id => "i-10000001")
  end

  def hadoop_slave_node(idx)
    Tengine::Resource::VirtualServer.find_or_create_by_name!(
      :addresses => hostnames_and_ips(idx + 10),
      :provider_id => provider.id,
      :provided_image_id => hadoop_image.provided_id,
      :host_server_id => availability_zone(1).id, :status => "available",
      :name => "hadoop_slave_node#{idx}", :provided_id => "i-1000001#{idx}")
  end

  def mysql_master
    Tengine::Resource::VirtualServer.find_or_create_by_name!(
      :addresses => hostnames_and_ips(20),
      :provider_id => provider.id,
      :provided_image_id => mysql_image.provided_id,
      :host_server_id => availability_zone(1).id, :status => "available",
      :name => "mysql_master", :provided_id => "i-10000020")
  end

  def mysql_slave(idx)
    Tengine::Resource::VirtualServer.find_or_create_by_name!(
      :addresses => hostnames_and_ips(idx + 20),
      :provider_id => provider.id,
      :provided_image_id => mysql_image.provided_id,
      :host_server_id => availability_zone(1).id, :status => "available",
      :name => "mysql_slave#{idx}", :provided_id => "i-1000002#{idx}")
  end

  def rails_server(idx)
    Tengine::Resource::VirtualServer.find_or_create_by_name!(
      :addresses => hostnames_and_ips(idx + 30),
      :provider_id => provider.id,
      :provided_image_id => rails_image.provided_id,
      :host_server_id => availability_zone(1).id, :status => "available",
      :name => "rails#{idx}", :provided_id => "i-1000003#{idx}")
  end

  private
  def hostnames_and_ips(idx)
    {
      'dns_name'           => "ec2-184-72-20-#{idx}.ap-northeast-1.compute.amazonaws.com",
      'ip_address'         =>     "184.72.20.#{idx}",
      'private_dns_name'   => "ip-10-162-153-#{idx}.ap-northeast-1.compute.internal",
      'private_ip_address' =>    "10.162.153.#{idx}",
    }
  end

end
