class Tengine::Resource::Provider::Ec2 < Tengine::Resource::Provider
  belongs_to :credential, :class_name => "Tengine::Resource::Credential"
  validates_presence_of :credential

  def update_physical_servers
    credential.connect do |conn|
       # ec2.describe_availability_zones  #=> [{:region_name=>"us-east-1",
       #                                        :zone_name=>"us-east-1a",
       #                                        :zone_state=>"available"}, ... ]
      conn.describe_availability_zones.each do |hash|
        name = hash[:zone_name]
        self.physical_servers.create!(:name => name, :provided_name => name, :status => hash[:zone_state])
        
      end
    end
    
  end
  
end
