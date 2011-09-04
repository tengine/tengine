class Tengine::Core::Handler
  include Mongoid::Document
  field :event_type_names, :type => Array
  array_text_accessor :event_type_names

  embedded_in :driver, :class_name => "Tengine::Core::Driver"

  def update_handler_path
    event_type_names.each do |event_type_name|
      Tengine::Core::HandlerPath.create!(:event_type_name => event_type_name,
        :driver => self.driver, :handler_id => self.id)
    end
  end

  def process_event(event, &block)
    block.call if match?(event)
  end

  def match?(event)
  end

end
