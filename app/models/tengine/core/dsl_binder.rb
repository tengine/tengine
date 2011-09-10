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
    filepath, lineno = *block.source_location
    handlers = @__driver__.handlers.where(
      :filepath => config.relative_path_from_dsl_dir(filepath),
      :lineno => lineno).to_a
    # 古い（なのに同じバージョンを使用している）Driverにはないハンドラが登録された場合は開発環境などでは十分ありえる
    if handlers.empty?
      # TODO こういう場合の例外は何を投げるべき？
      raise "Handler not found for #{filepath}:#{lineno}"
    end
    handlers.each do |handler|
      bind_blocks_for_handler_id(handler, &block)
    end
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
