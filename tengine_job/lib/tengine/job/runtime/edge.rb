# -*- coding: utf-8 -*-
require 'tengine/job/runtime'
require 'selectable_attr'

# Vertexとともにジョブネットを構成するグラフの「辺」を表すモデル
# Tengine::Job::Jobnetにembeddedされます。
class Tengine::Job::Runtime::Edge
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::SelectableAttr
  include Tengine::Job::Runtime::Signal::Transmittable
  include Tengine::Job::Structure::Visitor::Accepter

  class StatusError < StandardError
  end

  embedded_in :owner, :class_name => "Tengine::Job::Runtime::Jobnet", :inverse_of => :edges

  field :phase_cd     , :type => Integer, :default => 0 # ステータス。とりうる値は後述を参照してください。詳しくはtengine_jobパッケージ設計書の「edge状態遷移」を参照してください。
  field :origin_id     , :type => Moped::BSON::ObjectId # 辺の遷移元となるvertexのid
  field :destination_id, :type => Moped::BSON::ObjectId # 辺の遷移先となるvertexのid

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
    "#<#{self.class.name} #{name_for_message}>"
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
      self.phase_key = :closed
      signal.paths << self
      signal.with_paths_backup do
        if destination.is_a?(Tengine::Job::Job)
          destination.next_edges.first.transmit(signal)
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
      raise Tengine::Job::Edge::StatusError, "#{self.class.name}#complete not available on #{phase_key.inspect} at #{self.inspect}"
    end
  end

  def reset(signal)
    # 全てのステータスから遷移する
    if d = destination
      if signal.execution.in_scope?(d)
        self.phase_key = :active
        d.reset(signal)
      end
    else
      raise "destination not found: #{destination_id.inspect} from #{origin.inspect}"
    end
  end

  def close(signal)
    case phase_key
    when :active, :suspended, :keeping, :transmitting then
      self.phase_key = :closing
    end
  end

  def close_followings
    accept_visitor(Tengine::Job::Edge::Closer.new)
  end

  def phase_key=(phase_key)
    Tengine.logger.debug("edge phase changed. <#{self.id.to_s}> #{self.phase_name} -> #{Tengine::Job::Edge.phase_name_by_key(phase_key)}")
    self.write_attribute(:phase_cd, Tengine::Job::Edge.phase_id_by_key(phase_key))
  end

  class Closer
    def visit(obj)
      if obj.is_a?(Tengine::Job::End)
        if parent = obj.parent
          (parent.next_edges || []).each{|edge| edge.accept_visitor(self)}
        end
      elsif obj.is_a?(Tengine::Job::Vertex)
        obj.next_edges.each{|edge| edge.accept_visitor(self)}
      elsif obj.is_a?(Tengine::Job::Edge)
        obj.close(nil)
        obj.destination.accept_visitor(self)
      else
        raise "Unsupported class #{obj.inspect}"
      end
    end
  end

end
