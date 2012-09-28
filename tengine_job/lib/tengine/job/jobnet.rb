# -*- coding: utf-8 -*-
require 'tengine/job'

require 'selectable_attr'

# ジョブの始端から終端までを持ち、VertexとEdgeを組み合わせてジョブネットを構成することができるVertex。
# 自身もジョブネットを構成するVertexの一部として扱われる。
class Tengine::Job::Jobnet < Tengine::Job::Job
  include Tengine::Core::SelectableAttr
  include Tengine::Job::ElementSelectorNotation
  include Tengine::Core::SafeUpdatable

  autoload :Builder, "tengine/job/jobnet/builder"
  autoload :StateTransition, 'tengine/job/jobnet/state_transition'
  autoload :JobStateTransition, 'tengine/job/jobnet/job_state_transition'
  autoload :JobnetStateTransition, 'tengine/job/jobnet/jobnet_state_transition'

  field :script        , :type => String # 実行されるスクリプト(本来Tengine::Job::Scriptが保持しますが、子要素を保持してかつスクリプトを実行するhadoop_job_runもある)
  field :description   , :type => String # ジョブネットの説明
  field :jobnet_type_cd, :type => Integer, :default => 1 # ジョブネットの種類。後述の定義を参照してください。

  selectable_attr :jobnet_type_cd do
    entry 1, :normal        , "normal"
    entry 2, :finally       , "finally", :alternative => true
    # entry 3, :recover       , "recover", :alternative => true
    entry 4, :hadoop_job_run, "hadoop job run"
    entry 5, :hadoop_job    , "hadoop job"    , :chained_box => true
    entry 6, :map_phase     , "map phase"     , :chained_box => true
    entry 7, :reduce_phase  , "reduce phase"  , :chained_box => true
  end
  def chained_box?; jobnet_type_entry[:chained_box]; end

  embeds_many :edges, :class_name => "Tengine::Job::Edge", :inverse_of => :owner , :validate => false

  before_validation do |r|
    r.edges.each do |edge|
      unless edge.valid?
        edge.errors.each do |f, error|
          r.errors.add(:base, "#{edge.name_for_message} #{f.to_s.humanize} #{error}")
        end
      end
    end
  end

  class << self
    def by_name(name)
      where({:name => name}).first
    end
  end

  def script_executable?
    !script.blank?
  end

  def start_vertex
    self.children.detect{|child| child.is_a?(Tengine::Job::Start)}
  end

  def end_vertex
    self.children.detect{|child| child.is_a?(Tengine::Job::End)}
  end

  def finally_vertex
    self.children.detect{|child| child.is_a?(Tengine::Job::Jobnet) && (child.jobnet_type_key == :finally)}
  end
  alias_method :finally_jobnet, :finally_vertex

  def with_start
    self.children << Tengine::Job::Start.new
    self
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

  def child_by_name(str)
    case str
    when '..'      then parent
    when '.'       then self
    when 'start'   then start_vertex
    when 'end'     then end_vertex
    when 'finally' then finally_vertex
    else
      self.children.detect{|c| c.is_a?(Tengine::Job::Job) && (c.name == str)}
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
      next if child.is_a?(Tengine::Job::Jobnet) && !!child.jobnet_type_entry[:alternative]
      if current
        edge = self.new_edge(current, child)
        yield(edge) if block_given?
      end
      current = child
    end
  end

  def new_edge(origin, destination)
    origin_id = origin.is_a?(Tengine::Job::Vertex) ? origin.id : origin
    destination_id = destination.is_a?(Tengine::Job::Vertex) ? destination.id : destination
    edges.new(:origin_id => origin_id, :destination_id => destination_id)
  end

  def find_descendant_edge(edge_id)
    edge_id = String(edge_id)
    visitor = Tengine::Job::Vertex::AnyVisitor.new do |vertex|
      if vertex.respond_to?(:edges)
        vertex.edges.detect{|edge| edge.id.to_s == edge_id}
      else
        nil
      end
    end
    visitor.visit(self)
  end
  alias_method :edge, :find_descendant_edge

  def find_descendant(vertex_id)
    vertex_id = String(vertex_id)
    return nil if vertex_id == self.id.to_s
    vertex(vertex_id)
  end

  def vertex(vertex_id)
    vertex_id = String(vertex_id)
    return self if vertex_id == self.id.to_s
    visitor = Tengine::Job::Vertex::AnyVisitor.new{|v| vertex_id == v.id.to_s ? v : nil }
    visitor.visit(self)
  end

  def find_descendant_by_name_path(name_path)
    return nil if name_path == self.name_path
    vertex_by_name_path(name_path)
  end

  def vertex_by_name_path(name_path)
    Tengine::Job::NamePath.absolute?(name_path) ?
      root.vertex_by_absolute_name_path(name_path) :
      vertex_by_relative_name_path(name_path)
  end

  def vertex_by_absolute_name_path(name_path)
    return self if name_path.to_s == self.name_path
    visitor = Tengine::Job::Vertex::AnyVisitor.new do |vertex|
      if name_path == (vertex.respond_to?(:name_path) ? vertex.name_path : nil)
        vertex
      else
        nil
      end
    end
    visitor.visit(self)
  end

  def vertex_by_relative_name_path(name_path)
    head, tail = *name_path.split(Tengine::Job::NamePath::SEPARATOR, 2)
    child = child_by_name(head)
    tail ? child.vertex_by_relative_name_path(tail) : child
  end

end
