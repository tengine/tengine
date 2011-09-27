class Tengine::Job::JobnetTemplate
  include Mongoid::Document
  field :name, :type => String
  field :server_name, :type => String
  field :credential_name, :type => String
  field :killing_signals, :type => Array
  array_text_accessor :killing_signals
  field :killing_signal_interval, :type => Integer
  field :description, :type => String
  field :dsl_version, :type => String
  field :lock_version, :type => Integer
end
