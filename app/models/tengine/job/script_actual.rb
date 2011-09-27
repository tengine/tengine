class Tengine::Job::ScriptActual
  include Mongoid::Document
  field :name, :type => String
  field :server_name, :type => String
  field :credential_name, :type => String
  field :killing_signals, :type => Array
  array_text_accessor :killing_signals
  field :killing_signal_interval, :type => Integer
  field :script, :type => String
  field :has_chained_children, :type => Boolean
  field :executing_pid, :type => String
  field :exit_status, :type => String
  field :phase_cd, :type => Integer
  field :started_at, :type => Time
  field :finished_at, :type => Time
  field :stopped_at, :type => Time
  field :stop_reason, :type => String
end
