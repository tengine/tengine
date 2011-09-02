# -*- coding: utf-8 -*-
module Tengine::Core::DslLoader
  include Tengine::Core::DslEvaluator

  def driver(name, options = {}, &block)
    drivers = Tengine::Core::Driver.where(:name => name, :version => config.dsl_version)
    driver = nil
    # 指定した version の driver が見つかった場合にはデプロイ済みなので以降の処理は行わず処理を終了する
    if drivers.count == 0
      driver = Tengine::Core::Driver.new((options || {}).update(
          :name => name,
          :version => config.dsl_version
          ))
      @__driver__ = driver
      yield if block_given?
      driver.save!
    else
      driver = drivers.first
    end
    driver
  end

  def on(event_type_name, options = {}, &block)
    @__driver__.handlers.new(:event_type_names => [event_type_name.to_s])
  end
end
