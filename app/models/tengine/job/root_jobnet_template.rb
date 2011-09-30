class Tengine::Job::RootJobnetTemplate < Tengine::Job::JobnetTemplate
  include Tengine::Job::Root
  field :dsl_filepath, :type => String
  field :dsl_lineno, :type => Integer
  field :dsl_version, :type => String
end
