class Tengine::Resource::Provider::Ec2 < Tengine::Resource::Provider
  belongs_to :credential, :class_name => "Tengine::Resource::Credential"
  validates_presence_of :credential

  def update_physical_servers
    found_ids = []
    credential.connect do |conn|
      # ec2.describe_availability_zones  #=> [{:region_name=>"us-east-1",
      #                                        :zone_name=>"us-east-1a",
      #                                        :zone_state=>"available"}, ... ]
      # http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/index.html?ApiReference-query-DescribeAvailabilityZones.html
      conn.describe_availability_zones.each do |hash|
        name = hash[:zone_name]
        server = self.physical_servers.where(:provided_name => name).first
        if server
          server.update_attributes(:status => hash[:zone_state])
        else
          server = self.physical_servers.create!(:provided_name => name,
            :name => name, :status => hash[:zone_state])
        end
        found_ids << server.id
      end
    end
    self.physical_servers.not_in(:_id => found_ids).each do |server|
      server.update_attributes(:status => "not_found")
    end
  end
end
