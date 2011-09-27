class Tengine::Resource::Provider::Ec2 < Tengine::Resource::Provider
  belongs_to :credential, :class_name => "Tengine::Resource::Credential"
  validates_presence_of :credential

  def update_physical_servers
    credential.connect do |conn|
      # ec2.describe_availability_zones  #=> [{:region_name=>"us-east-1",
      #                                        :zone_name=>"us-east-1a",
      #                                        :zone_state=>"available"}, ... ]
      # http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/index.html?ApiReference-query-DescribeAvailabilityZones.html
      hashs = conn.describe_availability_zones.map do |hash|
        {
          :provided_name => hash[:zone_name],
          :name    => hash[:zone_name],
          :status => hash[:zone_state],
        }
      end
      update_physical_servers_by(hashs)
    end
  end

  def update_virtual_servers
    credential.connect do |conn|
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
          :provided_name => hash.delete(:aws_instance_id),
          :provided_image_name => hash.delete(:aws_image_id),
          :public_hostname  => hash.delete(:dns_name),
          :public_ipv4      => hash.delete(:ip_address),
          :private_hostname => hash.delete(:private_dns_name),
          :private_ipv4     => hash.delete(:private_ip_address),
          :status => hash.delete(:aws_state),
        }
        hash.delete(:aws_state_code)
        result[:properties] = hash
        result
      end
      update_virtual_servers_by(hashs)
    end
  end

end
