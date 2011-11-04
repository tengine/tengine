class Tengine::Resource::VirtualServerType
  include Mongoid::Document
  include Mongoid::Timestamps
  field :provided_id, :type => String
  field :properties, :type => Hash
  map_yaml_accessor :properties
  field :caption, :type => String
  referenced_in :provider, :inverse_of => :virtual_server_types, :index => true,
    :class_name => "Tengine::Resource::Provider"

  validates :provided_id, :presence => true, :uniqueness => {:scope => :provider_id}
  index [ [:provider_id, Mongo::ASCENDING] , [:provided_id, Mongo::ASCENDING] ], :unique => true
end
