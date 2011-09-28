class Tengine::Job::Job < Tengine::Job::Vertex
  include Tengine::Job::Connectable
  include Tengine::Job::Stoppable

  field :name, :type => String

  def short_inspect
    "#<%%%-30s id: %s name: %s>" % [self.class.name, self.id.to_s, name]
  end
  alias_method :long_inspect, :inspect
  alias_method :inspect, :short_inspect

end

