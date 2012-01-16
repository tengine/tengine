class Tengine::Test::Ssh
  include Mongoid::Document
  include Mongoid::Timestamps
  field :host, :type => String
  field :user, :type => String
  field :options, :type => Hash
  map_yaml_accessor :options
  field :command, :type => String
  field :timeout, :type => Integer
  field :stdout, :type => String
  field :stderr, :type => String
  field :error_message, :type => String
end
