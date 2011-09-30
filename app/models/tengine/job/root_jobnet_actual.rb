class Tengine::Job::RootJobnetActual < Tengine::Job::JobnetActual
  field :dsl_filepath, :type => String
  field :dsl_lineno, :type => Integer
  field :dsl_version, :type => String
  field :lock_version, :type => Integer
  referenced_in :category, :inverse_of => :root_jobnet_templates, :index => true, :class_name => "Tengine::Job::Category"
  belongs_to :template, :inverse_of => :root_jobnet_actuals, :index => true, :class_name => "Tengine::Job::RootJobnetTemplate"
end
