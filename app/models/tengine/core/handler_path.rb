class Tengine::Core::HandlerPath
  include Mongoid::Document
  field :event_type_name, :type => String
  field :handler_id, :type => Object

  belongs_to :driver, :index => true, :class_name => "Tengine::Core::Driver"
end
