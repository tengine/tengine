# -*- coding: utf-8 -*-
require 'pathname'

module Tengine::Core::DslLoader
  include Tengine::Core::DslEvaluator

  def driver(name, options = {}, &block)
    drivers = Tengine::Core::Driver.where(:name => name.to_s, :version => config.dsl_version)
    # 指定した version の driver が見つかった場合にはデプロイ済みなので以降の処理は行わず処理を終了する
    if drivers.count == 0
      @__driver__ = Tengine::Core::Driver.new((options || {}).update({
          :name => name,
          :version => config.dsl_version,
          :enabled => !config[:tengined][:skip_enablement],   # driverを有効化して登録するかのオプション
          }))
      yield if block_given?
      @__driver__.save!
    else
      Tengine::Core::stdout.warn("driver#{name.to_s.dump}は既に登録されています")
      @__driver__ = drivers.first
    end
    @__driver__
  end

  def on(event_type_name, options = {}, &block)
    filepath, lineno = *block.source_location
    path = Pathname.new(filepath)
    @__driver__.handlers.new(
      :filepath => path.relative? ? path.to_s : path.relative_path_from(Pathname.new(config.dsl_dir_path)).to_s,
      :lineno => lineno,
      :event_type_names => [event_type_name.to_s])
    # 一つのドライバに対して複数個のハンドラを登録しようとした際に警告を出すべきだが・・・
    # Tengine::Core::stdout.warn("driver#{@__driver__.name.dump}には、同一のevent_type_name#{event_type_name.to_s.dump}が複数存在します")
  end
end



