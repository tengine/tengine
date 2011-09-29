class Tengine::Job::RootJobnetTemplate < Tengine::Job::JobnetTemplate
  field :dsl_version, :type => String
  field :lock_version, :type => Integer
end
