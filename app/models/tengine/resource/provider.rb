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

end
