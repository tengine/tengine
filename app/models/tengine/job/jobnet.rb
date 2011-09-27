class Tengine::Job::Jobnet < Tengine::Job::Job
  include Tengine::Job::Root
  field :description, :type => String

  embeds_many :edges, :class_name => "Tengine::Job::Edge", :inverse_of => :owner
end
