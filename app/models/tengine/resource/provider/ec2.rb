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
end
