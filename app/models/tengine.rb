# -*- coding: utf-8 -*-

module Tengine
  autoload :Core, 'tengine/core'

  class << self
    def driver(name, options = {}, &block)
      client = eval("self", block.binding)
      driver = Tengine::Core::Driver.new((options || {}).update(
          :name => name,
          :version => client.instance_variable_get(:@__version__)
          ))
      client.instance_variable_set(:@__driver__, driver)
      yield if block_given?
      driver.save!
      driver
    end
  end

end
