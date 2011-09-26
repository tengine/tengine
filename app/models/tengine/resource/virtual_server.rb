class Tengine::Resource::VirtualServer < Tengine::Resource::Server
  field :provided_image_name, :type => String

  belongs_to :host, :inverse_of => :guests, :index => true,
    :class_name => "Tengine::Resource::Server"
  belongs_to :provider, :index => true, :inverse_of => :virtual_servers,
    :class_name => "Tengine::Resource::Provider"
end
