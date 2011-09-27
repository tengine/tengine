class Tengine::Job::ScriptActual < Tengine::Job::Script
  include Tengine::Job::RuntimeAttrs
  field :executing_pid, :type => String
  field :exit_status, :type => String
end
