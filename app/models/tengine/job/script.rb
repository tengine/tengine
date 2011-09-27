class Tengine::Job::Script < Tengine::Job::Job
  field :script, :type => String
  field :has_chained_children, :type => Boolean
end
