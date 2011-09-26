class Tengine::Resource::Credential
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :auth_type_cd, :type => String
  field :auth_values, :type => Hash
  map_yaml_accessor :auth_values
end
