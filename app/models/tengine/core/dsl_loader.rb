# -*- coding: utf-8 -*-
module Tengine::Core::DslLoader
  include Tengine::Core::DslEvaluator

  def driver(name, options = {}, &block)
    driver = Tengine::Core::Driver.new((options || {}).update(
        :name => name,
        :version => config.dsl_version
        ))
    @__driver__ = driver
    yield if block_given?
    driver.save!
    driver
  end

  def on(event_type_name, options = {}, &block)
    @__driver__.handlers.new(:event_type_names => [event_type_name.to_s])
  end
end
