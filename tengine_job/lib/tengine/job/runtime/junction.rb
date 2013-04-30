# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

# ForkやJoinの継承元となるVertex。特に状態は持たない。
class Tengine::Job::Runtime::Junction < Tengine::Job::Runtime::Vertex

  # https://cacoo.com/diagrams/hdLgrzYsTBBpV3Wj#D26C1
  def transmit(signal)
    complete_origin_edge(signal, :except_closed => true)
    # transmitted?で判断すると、closedなものに対する処理を考慮できないので、alive?を使って判断します
    # activate(signal) if prev_edges.all?(&:transmitted?)
    execution = signal.execution
    predicate = execution.retry ? :alive_or_closing_or_closed? : :alive_or_closing?
    unless signal.cache(prev_edges).any?(&predicate)
      activate(signal)
    end
  end

  def activatable?
    prev_edges.all?(&:transmitted?)
  end

  def activate(signal)
    Tengine.logger.debug "a" * 100
    Tengine.logger.debug "#{__FILE__}##{__LINE__}"
    Tengine.logger.debug "#{object_id} #{inspect}"
    Tengine.logger.debug "#{signal.cache(parent).object_id} #{signal.cache(parent).inspect}"
    signal.leave(self)
  end

  def reset(signal)
    signal.leave(self, :reset)
  end

end


# 一つのVertexから複数のVertexへSignalを通知する分岐のVertex。
class Tengine::Job::Runtime::Fork < Tengine::Job::Runtime::Junction
end

# 複数のVertexの終了を待ちあわせて一つのVertexへSignalを通知する合流のVertex。
class Tengine::Job::Runtime::Join < Tengine::Job::Runtime::Junction
end
