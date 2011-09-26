class Tengine::Resource::Server
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :provided_name, :type => String
  field :status, :type => String
  field :public_hostname, :type => String
  field :public_ipv4, :type => String
  field :local_hostname, :type => String
  field :local_ipv4, :type => String
  field :properties, :type => Hash
  map_yaml_accessor :properties
  field :provided_image_name, :type => String
  referenced_in :host, :inverse_of => :servers, :index => true
end
