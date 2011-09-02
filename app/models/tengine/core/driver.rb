class Tengine::Core::Driver
  include Mongoid::Document
  field :name, :type => String
  field :version, :type => String
  field :enabled, :type => Boolean
  field :enabled_on_activation, :type => Boolean

  embeds_many :handlers, :class_name => "Tengine::Core::Handler"
  has_many :handler_paths, :class_name => "Tengine::Core::HandlerPath"
end
