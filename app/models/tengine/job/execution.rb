class Tengine::Job::Execution
  include Mongoid::Document
  field :target_actual_ids, :type => Array
  array_text_accessor :target_actual_ids
  field :phase_cd, :type => Integer
  field :started_at, :type => Time
  field :finished_at, :type => Time
  field :preparation_command, :type => String
  field :actual_base_timeout_alert, :type => Integer
  field :actual_base_timeout_termination, :type => Integer
  field :estimated_time, :type => Integer
  field :keeping_stdout, :type => Boolean
  field :keeping_stderr, :type => Boolean
  belongs_to :root_jobnet, :class_name => "Tengine::Job::RootJobnetActual", :index => true #, :inverse_of => :executions
end
