class Tengine::Core::Handler
  include Mongoid::Document
  field :event_type_names, :type => Array
  array_text_accessor :event_type_names
end
