class Tengine::Core::Driver
  include Mongoid::Document
  field :name, :type => String
  field :version, :type => String
  field :enabled, :type => Boolean
end
