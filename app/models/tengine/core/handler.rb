class Tengine::Core::Handler
  include Mongoid::Document
  field :event_type_names, :type => Array
  array_text_accessor :event_type_names

  embedded_in :driver, :class_name => "Tengine::Core::Driver"
end
