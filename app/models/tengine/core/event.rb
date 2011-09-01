class Tengine::Core::Event
  include Mongoid::Document
  field :event_type_name, :type => String
  field :key, :type => String
  field :source_name, :type => String
  field :occurred_at, :type => Time
  field :notification_level, :type => Integer
  field :notification_confirmed, :type => Boolean
  field :sender_name, :type => String
  field :properties, :type => Hash
  map_yaml_accessor :properties
end
