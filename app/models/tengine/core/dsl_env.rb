# -*- coding: utf-8 -*-
class Tengine::Core::DslEnv
  attr_accessor :block_bindings

  def initialize
    @block_bindings = {}
  end

  def block_for(handler)
    block_bindings[handler.id.to_s]
  end

  def bind_blocks_for_handler_id(handler, &block)
    block_bindings[handler.id.to_s] = block
  end

  # デバッグ用の情報を表示します
  def to_a
    block_bindings.inject({}){|d, (handler_id, block)|
      f, l = block.source_location
      d["#{f}:#{l}"] = handler_id
      d
    }
  end

end
