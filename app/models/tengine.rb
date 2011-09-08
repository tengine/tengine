# -*- coding: utf-8 -*-

module Tengine
  autoload :Core, 'tengine/core'

  class << self
    def driver(*args, &block)
      client = eval("self", block.binding)
      client.driver(*args, &block)
    end
  end

end
