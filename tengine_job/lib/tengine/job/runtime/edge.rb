# -*- coding: utf-8 -*-
require 'tengine/job/runtime'
require 'selectable_attr'

# Vertexとともにジョブネットを構成するグラフの「辺」を表すモデル
# Tengine::Job::Runtime::Jobnetにembeddedされます。
class Tengine::Job::Runtime::Edge
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::SelectableAttr
  include Tengine::Job::Runtime::Signal::Transmittable
  include Tengine::Job::Structure::Visitor::Accepter

  class StatusError < StandardError
  end

  embedded_in :owner, :class_name => "Tengine::Job::Runtime::Jobnet", :inverse_of => :edges

  with_options(class_name: "Tengine::Job::Runtime::Vertex", inverse_of: nil) do |c|
    c.belongs_to :origin     , foreign_key: "origin_id"
    c.belongs_to :destination, foreign_key: "destination_id"
  end

  field :phase_cd     , :type => Integer, :default => 0 # ステータス。とりうる値は後述を参照してください。詳しくはtengine_jobパッケージ設計書の「edge状態遷移」を参照してください。

  validates :origin_id, :presence => true
  validates :destination_id, :presence => true

  selectable_attr :phase_cd do
    entry  0, :active      , "active"      , :alive => true
    entry 10, :transmitting, "transmitting", :alive => true
    entry 20, :transmitted , "transmitted" , :alive => false
    entry 30, :suspended   , "suspended"   , :alive => true
    entry 31, :keeping     , "keeping"     , :alive => true
    entry 40, :closing     , "closing"     , :alive => false
    entry 50, :closed      , "closed"      , :alive => false
  end

  def alive?; !!phase_entry[:alive]; end
  def alive_or_closing?; alive? || closing?; end
  def alive_or_closing_or_closed?; alive? || closing? || closed?; end

  phase_keys.each do |phase_key|
    class_eval(<<-END_OF_METHOD)
      def #{phase_key}?; phase_key == #{phase_key.inspect}; end
    END_OF_METHOD
  end

  def origin
    owner.children.detect{|c| c.id == origin_id}
  end

  def destination
    owner.children.detect{|c| c.id == destination_id}
  end

  def name_for_message
    "edge(#{id.to_s}) from #{origin ? origin.name_path : 'no origin'} to #{destination ? destination.name_path : 'no destination'}"
  end

  def inspect
    "#<#{self.class.name} #{phase_key.inspect} #{name_for_message}>"
  end

  # https://cacoo.com/diagrams/hdLgrzYsTBBpV3Wj#3E9EA
  def transmit(signal)
    case phase_key
    when :active then
      d = destination
      if signal.execution.in_scope?(d)
        self.phase_key = :transmitting
        signal.leave(self)
      else
        Tengine.logger.info("#{d.name_path} will not be executed, becauase it is out of execution scope.")
      end
    when :suspended then
      self.phase_key = :keeping
    when :closing then

Tengine.logger.debug "c" * 100
Tengine.logger.debug "#{object_id} #{inspect}"
# Tengine.logger.debug caller[0, 20].join("\n  ")

# binding.pry

      self.phase_key = :closed
      signal.paths << self
      signal.with_paths_backup do
        if destination.is_a?(Tengine::Job::Runtime::NamedVertex)
          signal.cache(destination.next_edges.first).transmit(signal)
        else
          signal.leave(self)
        end
      end
    end
  end

  def complete(signal)
    case phase_key
    when :transmitting then
      self.phase_key = :transmitted
    when :active, :closed then
      # IG
    when :suspended, :keeping then
      # N/A
      raise Tengine::Job::Runtime::Edge::StatusError, "#{self.class.name}#complete not available on #{phase_key.inspect} at #{self.inspect}"
    end
  end

  def reset(signal)
    # 全てのステータスから遷移する
    if d = destination
      if signal.execution.in_scope?(d)
        self.phase_key = :active

        signal.call_later do
          d.reset(signal)
        end
      end
    else
      raise "destination not found: #{destination_id.inspect} from #{origin.inspect}"
    end
  end

  def close(signal)
    case phase_key
    when :active, :suspended, :keeping, :transmitting then
      self.phase_key = :closing
    when :closing, :closed then
      # ignored
    else
      Tengine.logger.warn "#{object_id} #{inspect} wasn't closed"
    end
  end

  def close_followings(signal, options = {})
    v = Tengine::Job::Runtime::Edge::Closer.new(signal, options)
    accept_visitor(v)
    v.closed_edges
  end

  # ownerのupdate_with_lockを使っています。
  def close_followings_and_trasmit(signal)
    jobnet = signal.cache(self.owner)
    closing_edges = nil
    closed_edges = []
    jobnet.update_with_lock do
      closing_edges = self.close_followings(signal)
      closing_edges.each do |e|
        next unless e.owner.id == jobnet.id
        je = signal.cache(e) # jobnet単位で保存するので、jobnetオブエジェクトに紐付けられたものを見つける
        je.close(nil)
        closed_edges << e
      end
      # jobnetオブジェクトのedgesに含まれないエッジについては、そのowner毎にまとめて保存する
      self.transmit(signal)

      Tengine.logger.debug "<" * 100
      Tengine.logger.debug "#{__FILE__}##{__LINE__}"
      jobnet.edges.each do |edge|
        Tengine.logger.debug "#{edge.object_id} #{edge.inspect} BEFORE end of block for update_with_lock"
      end
    end
    # signal.cache_list
    signal.changed_vertecs.each(&:save!)
  end

  def phase_key=(phase_key)
    # Tengine.logger.debug("edge phase changed. <#{self.id.to_s}> #{self.phase_name} -> #{Tengine::Job::Runtime::Edge.phase_name_by_key(phase_key)}")
    Tengine.logger.debug("#{object_id} edge phase changed. <#{inspect}> #{self.phase_name} -> #{Tengine::Job::Runtime::Edge.phase_name_by_key(phase_key)}")
    self.write_attribute(:phase_cd, Tengine::Job::Runtime::Edge.phase_id_by_key(phase_key))
  end

  class Closer
    attr_reader :closed_edges
    def initialize(signal, options = {})
      @signal = signal
      @closed_edges = []
    end

    def close(edge)
      edge.close(@signal)
      @closed_edges << edge
    end

    def visit(obj)
# binding.pry
      obj = @signal.remember(obj)
      if obj.is_a?(Tengine::Job::Runtime::End)
        if parent = obj.parent
          (parent.next_edges || []).each{|edge| edge.accept_visitor(self)}
        end
      elsif obj.is_a?(Tengine::Job::Runtime::Vertex)
        obj.next_edges.each{|edge| edge.accept_visitor(self)}
      elsif obj.is_a?(Tengine::Job::Runtime::Edge)
        close(obj)
        @signal.cache(obj.destination).accept_visitor(self)
      else
        raise "Unsupported class #{obj.inspect}"
      end
    end
  end

end
