class Tengine::Core::HandlerPath
  include Mongoid::Document
  field :event_type_name, :type => String
  field :handler_id, :type => Object
  referenced_in :driver, :inverse_of => :handler_paths, :index => true
end
