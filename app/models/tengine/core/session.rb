class Tengine::Core::Session
  include Mongoid::Document
  field :properties, :type => Hash
  map_yaml_accessor :properties

  belongs_to :driver, :index => true, :class_name => "Tengine::Core::Driver"
end
