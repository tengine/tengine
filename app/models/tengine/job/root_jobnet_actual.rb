class Tengine::Job::RootJobnetActual < Tengine::Job::JobnetActual
  include Tengine::Job::Root
  field :lock_version, :type => Integer
  belongs_to :template, :inverse_of => :root_jobnet_actuals, :index => true, :class_name => "Tengine::Job::RootJobnetTemplate"
end
