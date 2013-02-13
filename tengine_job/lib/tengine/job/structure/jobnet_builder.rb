# -*- coding: utf-8 -*-
require 'tengine/job/structure'

module Tengine::Job::Structure::JobnetBuilder

  def start_vertex
    self.children.detect{|child| child.is_a?(self.class.start_vertex_class)}
  end

  def end_vertex
    self.children.detect{|child| child.is_a?(self.class.end_vertex_class)}
  end

  def finally_vertex
    self.children.detect{|child| child.is_a?(self.class.jobnet_class) && (child.jobnet_type_key == :finally)}
  end
  alias_method :finally_jobnet, :finally_vertex

  def with_start
    self.children << self.class.start_vertex_class.new
    self
  end

  def prepare_end
    if self.children.last.is_a?(self.class.end_vertex_class)
      _end = self.children.last
      yield(_end) if block_given?
    else
      _end = self.class.end_vertex_class.new
      yield(_end) if block_given?
      self.children << _end
    end
    _end
  end

  def child_by_name(str)
    case str
    when '..'      then parent
    when '.'       then self
    when 'start'   then start_vertex
    when 'end'     then end_vertex
    when 'finally' then finally_vertex
    else
      self.children.detect{|c| c.respond_to?(:name) && (c.name == str)}
    end
  end

  def build_edges(auto_sequence, boot_job_names, redirections)
    if self.children.length == 1 # 最初に追加したStartだけなら。
      self.children.delete_all
      return
    end
    if auto_sequence || boot_job_names.empty?
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
      next if child.is_a?(self.class.jobnet_class) && !!child.jobnet_type_entry[:alternative]
      if current
        edge = self.new_edge(current, child)
        yield(edge) if block_given?
      end
      current = child
    end
  end

  def new_edge(origin, destination)
    origin_id = origin.is_a?(self.class.vertex_class) ? origin.id : origin
    destination_id = destination.is_a?(self.class.vertex_class) ? destination.id : destination
    edges.new(:origin_id => origin_id, :destination_id => destination_id)
  end
end
