# -*- coding: utf-8 -*-
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
    # 一つの driver で、同じ event_type_name で複数の handler が登録されていた場合には、Rubyの言語仕様っぽく後勝ちになります
    # よって DSL で後に記述された block が event_type_name に対応した handler の処理として紐付けられます
    # この曖昧な制約をなくすには、Tengine::Core::DslLoader で複数の event_type_name を登録できないようにする、もしくは
    # 複数でも一つの handler として扱うかにする必要があります
    handlers.each do |handler|
      bind_blocks_for_handler_id(handler.id, &block)
    end
  end
end
