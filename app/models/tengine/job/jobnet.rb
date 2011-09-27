class Tengine::Job::Jobnet < Tengine::Job::Job
  include Tengine::Job::Root
  field :description, :type => String
  field :jobnet_type_cd, :type => Integer

  embeds_many :edges, :class_name => "Tengine::Job::Edge", :inverse_of => :owner


  def build_sequencial_edges
    self.edges.clear
    unless self.children.first.is_a?(Tengine::Job::Start)
      self.children.unshift(Tengine::Job::Start.new)
    end
    unless self.children.last.is_a?(Tengine::Job::End)
      self.children.push(Tengine::Job::End.new)
    end
    current = nil
    self.children.each do |child|
      if current
        self.edges.new(:origin_id => current.id, :destination_id =>child.id)
      end
      current = child
      child.build_sequencial_edges if child.respond_to?(:build_sequencial_edges)
    end
  end

end
