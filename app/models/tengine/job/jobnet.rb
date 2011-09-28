# -*- coding: utf-8 -*-
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

  after_initialize :build_start

  class << self
    def by_name(name)
      first(:conditions => {:name => name})
    end
  end

  def build_start
    return unless self.children.empty?
    self.children << Tengine::Job::Start.new
  end

  def prepare_end
    if self.children.last.is_a?(Tengine::Job::End)
      _end = self.children.last
      yield(_end) if block_given?
    else
      _end = Tengine::Job::End.new
      yield(_end) if block_given?
      self.children << _end
    end
    _end
  end

  def finally_jobnet
    self.children.detect{|c| c.is_a?(Tengine::Job::Jobnet) && (c.jobnet_type_key == :finally)}
  end

  def child_by_name(name)
    self.children.detect{|c| c.is_a?(Tengine::Job::Job) && (c.name == name)}
  end

  def build_edges(auto_sequence, boot_job_names, redirections)
    if self.children.length == 1 # 最初に追加したStartだけなら。
      self.children.delete_all
      return
    end
    if auto_sequence
      prepare_end
      build_sequencial_edges
    else
      Builder.new(self, boot_job_names, redirections).process
    end
  end

  def build_sequencial_edges
    self.edges.clear
    current = nil
    self.children.each do |child|
      next if child.is_a?(Tengine::Job::Jobnet) && (child.jobnet_type_key != :normal)
      if current
        self.new_edge(current, child)
      end
      current = child
    end
  end

  def new_edge(origin, destination)
    origin_id = origin.is_a?(Tengine::Job::Vertex) ? origin.id : origin
    destination_id = destination.is_a?(Tengine::Job::Vertex) ? destination.id : destination
    edges.new(:origin_id => origin_id, :destination_id => destination_id)
  end

end
