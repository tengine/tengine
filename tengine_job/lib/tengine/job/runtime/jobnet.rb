# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

require 'selectable_attr'

# ジョブの始端から終端までを持ち、VertexとEdgeを組み合わせてジョブネットを構成することができるVertex。
# 自身もジョブネットを構成するVertexの一部として扱われる。
class Tengine::Job::Runtime::Jobnet < Tengine::Job::Runtime::NamedVertex
  include Tengine::Core::SelectableAttr
  include Tengine::Core::SafeUpdatable

  include Tengine::Job::Structure::JobnetBuilder
  include Tengine::Job::Structure::JobnetFinder
  include Tengine::Job::Structure::ElementSelectorNotation

  include Tengine::Job::Runtime::StateTransition

  field :description   , :type => String # ジョブネットの説明

  field :was_expansion, :type => Boolean # テンプレートがTenigne::Job::Expansionであった場合にtrueです。

  # was_expansionがtrueなら元々のtemplateへの参照が必要なのでTenigne::Job::Runtime::RootJobnetだけでなく
  # JobnetActualでもtemplateが必要です。
  belongs_to :template, :inverse_of => :root_jobnet_actuals, :index => true, :class_name => "Tengine::Job::Template::RootJobnet"

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

  embeds_many :edges, :class_name => "Tengine::Job::Runtime::Edge", :inverse_of => :owner , :validate => false

  before_validation do |r|
    r.edges.each do |edge|
      unless edge.valid?
        edge.errors.each do |f, error|
          r.errors.add(:base, "#{edge.name_for_message} #{f.to_s.humanize} #{error}")
        end
      end
    end
  end

  VERTEX_CLASSES = {
    vertex: "Vertex",
    start_vertex: "Start",
    end_vertex: "End",
    jobnet: "Jobnet",
    fork: "Fork",
    join: "Join",
  }.freeze

  VERTEX_CLASSES.each do |key, value|
    instance_eval("def #{key}_class; Tengine::Job::Runtime::#{value}; end", __FILE__, __LINE__)
  end

  attr_reader :stop_modified
  before_save :check_stop_modified
  after_save :update_children_stop_modified, if: :stop_modified

  def check_stop_modified
    @stop_modified = stop_reason_changed? || stopped_at_changed?
    true
  end

  def update_children_stop_modified
    @stop_modified = false
    children.each do |child|
      if child.is_a?(Tengine::Job::Runtime::Stoppable) && child.respond_to?(:chained_box?) && child.chained_box?
        child.stop_reason = stop_reason
        child.stopped_at = stopped_at
        child.save!
      end
    end
  end

  class << self
    def by_name(name)
      where({:name => name}).first
    end
  end

  # @override
  def ancestors_until_expansion
    if (parent = self.parent) && !self.was_expansion?
      parent.ancestors_until_expansion + [parent]
    else
      []
    end
  end

  # TODO このメソッドは削除するべき。これを使わないで動くようにする。
  def script_executable?
    false
  end

  ## 状態遷移アクション

  # ハンドリングするドライバ: ジョブネット制御ドライバ or ジョブ起動ドライバ
  def transmit(signal)
    self.phase_key = :ready
    signal.fire(self, :"start.jobnet.job.tengine", {
        :target_jobnet_id => self.id,
        :target_jobnet_name_path => self.name_path,
      })
  end
  available(:transmit, :on => :initialized,
    :ignored => [:ready, :starting, :running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  def activate(signal)
    self.phase_key = :starting
    self.started_at = signal.event.occurred_at
    complete_origin_edge(signal) if prev_edges && !prev_edges.empty?
    (parent || signal.execution).ack(signal)
    signal.paths << self
    self.start_vertex.transmit(signal)
  end
  available(:activate, :on => :ready,
    :ignored => [:starting, :running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  # このackは、子要素のTengine::Job::Runtime::Start#activateから呼ばれます
  def ack(signal)
    self.phase_key = :running
  end
  available(:ack, :on => [:initialized, :ready, :starting],
    :ignored => [:running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  # このackは、子要素のTengine::Job::End#activateから呼ばれます
  def finish(signal)

    Tengine.logger.info("#{__FILE__}##{__LINE__} #{self.class}#finish")

    edge = signal.cache(end_vertex.prev_edges).first
    edge.closed? ?
    self.fail(signal) :
      succeed(signal)
  end

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  def succeed(signal)
    self.phase_key = :success
    self.finished_at = signal.event.occurred_at
    signal.fire(self, :"success.jobnet.job.tengine", {
        :target_jobnet_id => self.id,
        :target_jobnet_name_path => self.name_path,
      })
  end
  available :succeed, :on => [:starting, :running, :dying, :stuck, :error], :ignored => [:success]

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  def fail(signal)
    Tengine.logger.info("#{__FILE__}##{__LINE__} #{self.class}#fail")

    return if signal.cache(self.edges).any?(&:alive?)
    self.phase_key = :error
    self.finished_at = signal.event.occurred_at
    signal.fire(self, :"error.jobnet.job.tengine", {
        :target_jobnet_id => self.id,
        :target_jobnet_name_path => self.name_path,
      })
  end
  available :fail, :on => [:starting, :running, :dying, :success], :ignored => [:error, :stuck]

  def fire_stop(signal)
    return if self.phase_key == :initialized
    signal.fire(self, :"stop.jobnet.job.tengine", {
        :target_jobnet_id => self.id,
        :target_jobnet_name_path => self.name_path,
        :stop_reason => signal.event[:stop_reason]
      })
  end

  def stop(signal)
    self.phase_key = :dying
    self.stopped_at = signal.event.occurred_at
    self.stop_reason = signal.event[:stop_reason]
    close(signal)
    children.each do |child|
      child.fire_stop(signal) if child.respond_to?(:fire_stop)
    end
  end
  available :stop, :on => [:initialized, :ready, :starting, :running], :ignored => [:dying, :success, :error, :stuck]

  def close(signal)
    self.edges.each{|edge| signal.cache(edge).close(signal)}
  end


  def reset(signal, &block)
    # children.each{|c| c.reset(signal) }
    self.phase_key = :initialized
    if s = start_vertex
      s.reset(signal)
    end
    if edge = signal.cache((next_edges || [])).first
      edge.reset(signal)
    end
  rescue Exception => e
    puts "#{self.name_path} [#{e.class}] #{e.message}"
    raise
  end
  available :reset, :on => [:initialized, :success, :error, :stuck]

end




# ジョブネットの始端を表すVertex。特に状態は持たない。
class Tengine::Job::Runtime::Start < Tengine::Job::Runtime::Vertex
  # https://cacoo.com/diagrams/hdLgrzYsTBBpV3Wj#D26C1
  def transmit(signal)
    activate(signal)
  end

  def activate(signal)
    signal.leave(self)
  end

  def reset(signal)
    signal.leave(self, :reset)
  end
end


# ジョブネットの終端を表すVertex。特に状態は持たない。
class Tengine::Job::Runtime::End < Tengine::Job::Runtime::Vertex
  # https://cacoo.com/diagrams/hdLgrzYsTBBpV3Wj#D26C1
  def transmit(signal)
    activate(signal)
  end

  def activate(signal)
    complete_origin_edge(signal, :except_closed => true)
    parent = self.parent # Endのparentであるジョブネット
    parent_finally = parent.finally_vertex
    if parent_finally && (parent.phase_key != :dying)
      parent_finally.transmit(signal)
    else
      parent.finish(signal) unless parent.phase_key == :stuck
    end
  end

  def reset(signal)

    Tengine.logger.info("#{__FILE__}##{__LINE__} #{self.class}#reset")

    parent = self.parent # Endのparentであるジョブネット
    if signal.execution.in_scope?(parent)
      if f = parent.finally_vertex
        f.reset(signal)
      end
    end
  end
end
