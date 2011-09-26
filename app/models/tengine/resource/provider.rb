class Tengine::Resource::Provider
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String

  with_options(:inverse_of => :provider, :dependent => :destroy) do |c|
    c.has_many :physical_servers       , :class_name => "Tengine::Resource::PhysicalServer"
    c.has_many :virtual_servers        , :class_name => "Tengine::Resource::VirtualServer"
    c.has_many :virtual_server_imagess , :class_name => "Tengine::Resource::VirtualServerImage"
  end

  validates_presence_of :name

  def update_physical_servers      ; raise NotImplementedError end
  def update_virtual_servers       ; raise NotImplementedError end
  def update_virtual_server_imagess; raise NotImplementedError end

  private
  def update_physical_servers_by(hashs)
    found_ids = []
    hashs.each do |hash|
      server = self.physical_servers.where(:provided_name => hash[:provided_name]).first
      if server
        server.update_attributes(:status => hash[:status])
      else
        server = self.physical_servers.create!(
          :provided_name => hash[:provided_name],
          :name => hash[:name],
          :status => hash[:status])
      end
      found_ids << server.id
    end
    self.physical_servers.not_in(:_id => found_ids).each do |server|
      server.update_attributes(:status => "not_found")
    end
  end
end
