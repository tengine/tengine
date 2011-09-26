class Tengine::Resource::VirtualServerImage
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :provided_name, :type => String
  belongs_to :provider, :inverse_of => :virtual_server_images, :index => true,
    :class_name => "Tengine::Resource::Provider"
end
