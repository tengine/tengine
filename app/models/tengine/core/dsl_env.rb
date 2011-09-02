# -*- coding: utf-8 -*-
class Tengine::Core::DslEnv
  attr_accessor :block_bindings

  def initialize
    @block_bindings ||= {}
  end

  def remember_block
  end

  def bind_blocks_for_handler_id(handler_id, &block)
    block_bindings[handler_id] ||= []
    block_bindings[handler_id] << block
  end
end
