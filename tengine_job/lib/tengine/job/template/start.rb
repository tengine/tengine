# -*- coding: utf-8 -*-
require 'tengine/job/template'

# ジョブネットの始端を表すVertex。特に状態は持たない。
class Tengine::Job::Template::Start < Tengine::Job::Template::Vertex

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
