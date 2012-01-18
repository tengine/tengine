class Tengine::Test::Script
  include Mongoid::Document
  include Mongoid::Timestamps
  field :kind, :type => String
  field :code, :type => String
  field :options, :type => Hash
  map_yaml_accessor :options
  field :timeout, :type => Integer
  field :messages, :type => Hash
  map_yaml_accessor :messages
end
