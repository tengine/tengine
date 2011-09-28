class Tengine::Job::Jobnet < Tengine::Job::Job
  include SelectableAttr::Base

  include Tengine::Job::Root
  field :script, :type => String
  field :description, :type => String
  field :jobnet_type_cd, :type => Integer, :default => 1

  selectable_attr :jobnet_type_cd do
    entry 1, :normal , "normal"
    entry 2, :finally, "finally"
    # entry 3, :recover, "recover"
  end

  embeds_many :edges, :class_name => "Tengine::Job::Edge", :inverse_of => :owner

  class << self
    def by_name(name)
      first(:conditions => {:name => name})
    end
  end

  def prepare_start_and_end
    unless self.children.first.is_a?(Tengine::Job::Start)
      self.children.unshift(Tengine::Job::Start.new)
    end
    unless self.children.last.is_a?(Tengine::Job::End)
      self.children.push(Tengine::Job::End.new)
    end
  end

  def build_sequencial_edges
    self.edges.clear
    current = nil
    self.children.each do |child|
      next if child.is_a?(Tengine::Job::Jobnet) && (child.jobnet_type_key != :normal)
      if current
        self.edges.new(:origin_id => current.id, :destination_id =>child.id)
      end
      current = child
    end
  end

  def finally_jobnet
    self.children.detect{|c| c.is_a?(Tengine::Job::Jobnet) && (c.jobnet_type_key == :finally)}
  end


end
