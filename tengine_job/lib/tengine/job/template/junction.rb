# -*- coding: utf-8 -*-
require 'tengine/job/template'

# ForkやJoinの継承元となるVertex。特に状態は持たない。
class Tengine::Job::Template::Junction < Tengine::Job::Template::Vertex

  # https://cacoo.com/diagrams/hdLgrzYsTBBpV3Wj#D26C1
  def transmit(signal)
    complete_origin_edge(signal, :except_closed => true)
    # transmitted?で判断すると、closedなものに対する処理を考慮できないので、alive?を使って判断します
    # activate(signal) if prev_edges.all?(&:transmitted?)
    execution = signal.execution
    predicate = execution.retry ? :alive_or_closing_or_closed? : :alive_or_closing?
    activate(signal) unless prev_edges.any?(&predicate)
  end

  def activatable?
    prev_edges.all?(&:transmitted?)
  end

  def activate(signal)
    signal.leave(self)
  end

  def reset(signal)
    signal.leave(self, :reset)
  end

end


# 一つのVertexから複数のVertexへSignalを通知する分岐のVertex。
class Tengine::Job::Template::Fork < Tengine::Job::Template::Junction
end

# 複数のVertexの終了を待ちあわせて一つのVertexへSignalを通知する合流のVertex。
class Tengine::Job::Template::Join < Tengine::Job::Template::Junction
end
