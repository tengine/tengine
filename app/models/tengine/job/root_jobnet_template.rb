class Tengine::Job::RootJobnetTemplate
  include Mongoid::Document
  field :name, :type => String
  field :server_name, :type => String
  field :credential_name, :type => String
  field :killing_signals, :type => Array
  array_text_accessor :killing_signals
  field :killing_signal_interval, :type => Integer
  field :description, :type => String
  field :script, :type => String
  field :jobnet_type_cd, :type => Integer
  field :dsl_version, :type => String
  field :lock_version, :type => Integer
end
