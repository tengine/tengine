# -*- coding: utf-8 -*-
class Tengine::Core::DslEnv
  attr_accessor :block_bindings

  def initialize
    @block_bindings = {}
  end

  def block_for(handler)
    block_bindings[handler.id]
  end

  def bind_blocks_for_handler_id(handler, &block)
    block_bindings[handler.id] = block
  end
end
