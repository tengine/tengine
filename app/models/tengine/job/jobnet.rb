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
      build_start_edges(boot_job_names)
      build_edge_by_redirections(redirections)
      prepare_end do |_end|
        build_end_edges(_end, boot_job_names.map{|jn| [:start, jn]} + redirections)
      end
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

  def build_start_edges(boot_job_names)
    start = children.first
    case boot_job_names.length
    when 0 then raise "Must be a bug!!!"
    when 1 then
      edges.new(:origin_id => start.id,
        :destination_id => child_by_name(boot_job_names.first).id)
    else
      fork = Tengine::Job::Fork.new
      children << fork
      edges.new(:origin_id => start.id, :destination_id => fork.id)
      boot_job_names.each do |boot_job_name|
        j = child_by_name(boot_job_name)
        edges.new(:origin_id => fork.id, :destination_id => j.id)
      end
    end
  end

  def build_edge_by_redirections(redirections)
    fork_node_counts = redirections.inject({}) do |d, (_start, _end)|
      d[_start] ||= 0; d[_start] += 1; d
    end
    join_node_counts = redirections.inject({}) do |d, (_start, _end)|
      d[_end  ] ||= 0; d[_end  ] += 1; d
    end
    fork_node_counts.delete_if{|k,v| v < 2}
    join_node_counts.delete_if{|k,v| v < 2}
    # puts "fork:" << fork_node_counts.inspect
    # puts "join:" << join_node_counts.inspect
    fork_node_counts.keys.each do |fork_from|
      fork = Tengine::Job::Fork.new
      children << fork
      edges.new(
        :origin_id => child_by_name(fork_from).id,
        :destination_id => fork.id)
      redirections.each do |(_start, _end)|
        next unless _start == fork_from
        edges.new(
          :origin_id => fork.id,
          :destination_id => child_by_name(_end).id)
      end
    end
    join_node_counts.keys.each do |join_to|
      join = Tengine::Job::Join.new
      children << join
      redirections.each do |(_start, _end)|
        next unless _end == join_to
        edges.new(
          :origin_id => child_by_name(_start).id,
          :destination_id => join.id)
      end
      edges.new(
        :origin_id => join.id,
        :destination_id => child_by_name(join_to).id)
    end
  end

  def build_end_edges(_end, redirections)
    end_points = select_end_points(redirections)
    case end_points.length
    when 0 then raise "Must be a bug!!!"
    when 1 then edges.new(:origin_id => child_by_name(end_points.first).id,
        :destination_id => _end.id)
    else
      join = Tengine::Job::Join.new
      children << join
      end_points.each do |end_point|
        j = child_by_name(end_point)
        edges.new(:origin_id => j.id, :destination_id => join.id)
      end
      edges.new(:origin_id =>join.id, :destination_id => _end.id)
    end
  end

  def select_end_points(redirections)
    nodes = redirections.flatten.uniq
    redirections.each do |(_start, _end)|
      nodes.delete(_start)
    end
    nodes
  end
end
