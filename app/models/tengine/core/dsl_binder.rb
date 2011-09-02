# -*- coding: utf-8 -*-
require 'eventmachine'
require 'tengine/event'

module Tengine::Core::DslBinder
  include Tengine::Core::DslEvaluator

  def driver(name, options = {}, &block)
    drivers = Tengine::Core::Driver.where(:name => name, :version => config.dsl_version)
    # 指定した version の driver が見つからなかった場合にはデプロイされていないのでエラー
    if drivers.count == 1
      @__driver__ = drivers.first
      yield if block_given?
    else
      raise Tengine::Core::VersionError, "version mismatch. #{config.dsl_version}"
    end
    @__driver__
  end

  def on(event_type_name, options = {}, &block)
    handlers = @__driver__.handlers.where(:event_type_names => [event_type_name.to_s])
    # 一つの driver で、同じ event_type_name で複数の handler が記述されている場合には、一つの handler として扱い、
    # block を複数利用できるようにします
    unless handlers.count == 1
      raise StandardError, "[DslBinder][error] driver\"#{@__driver__.name}\"には、event_type_name\"#{event_type_name}\"へのhandlerが複数存在します"
    end
    handler = handlers.first
    bind_blocks_for_handler_id(handler.id, &block)
  end

  def fire(event_type_name, options = {})
    Tengine::Event.config = {
      :connection => config[:event_queue][:connection],
      :exchange => config[:event_queue][:exchange],
      :queue => config[:event_queue][:queue]
    }
    Tengine::Event.fire(event_type_name, options)
  end
end
