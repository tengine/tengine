class Tengine::Core::Setting
  include Mongoid::Document
  field :name, :type => String
  field :value, :type => String
end
