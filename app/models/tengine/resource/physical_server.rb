class Tengine::Resource::PhysicalServer < Tengine::Resource::Server
  belongs_to :provider, :index => true, :inverse_of => :physical_servers,
    :class_name => "Tengine::Resource::Provider"
end
