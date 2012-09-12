require 'tengine/resource'

class Tengine::Resource::VirtualServerType
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::CollectionAccessible
  include Tengine::Core::Validation

  field :provided_id, :type => String
  field :caption, :type => String
  field :cpu_cores, :type => Integer
  field :memory_size, :type => Integer
  field :properties, :type => Hash
  map_yaml_accessor :properties

  belongs_to :provider, :inverse_of => :virtual_server_types, :index => true,
    :class_name => "Tengine::Resource::Provider"

  validates :provided_id, :presence => true, :uniqueness => {:scope => :provider_id}
  index({provider_id: 1, provided_id: 1}, {unique: true})
end
