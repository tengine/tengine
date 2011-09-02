class Tengine::Core::Driver
  include Mongoid::Document
  field :name, :type => String
  field :version, :type => String
  field :enabled, :type => Boolean
  field :enabled_on_activation, :type => Boolean
end
