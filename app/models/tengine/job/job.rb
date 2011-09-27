class Tengine::Job::Job
  include Mongoid::Document
  field :name, :type => String
  field :server_name, :type => String
  field :credential_name, :type => String
  field :killing_signals, :type => Array
  array_text_accessor :killing_signals
  field :killing_signal_interval, :type => Integer
end
