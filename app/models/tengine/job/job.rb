class Tengine::Job::Job < Tengine::Job::Vertex
  include Tengine::Job::Connectable
  include Tengine::Job::Stoppable

  field :name, :type => String

end
