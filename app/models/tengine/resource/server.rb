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

  has_many :guest, :class_name => "Tengine::Resource::VirtualServer", :inverse_of => :host
end
