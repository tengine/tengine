class Tengine::Core::Session
  include Mongoid::Document
  field :properties, :type => Hash
  map_yaml_accessor :properties
end
