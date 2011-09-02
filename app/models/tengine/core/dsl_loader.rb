# -*- coding: utf-8 -*-
module Tengine::Core::DslLoader
  include Tengine::Core::DslEvaluator

  def driver(name, options = {}, &block)
    drivers = Tengine::Core::Driver.where(:name => name, :version => config.dsl_version)
    # 指定した version の driver が見つかった場合にはデプロイ済みなので以降の処理は行わず処理を終了する
    if drivers.count == 0
      @__driver__ = Tengine::Core::Driver.new((options || {}).update(
          :name => name,
          :version => config.dsl_version
          ))
      yield if block_given?
      @__driver__.save!
    else
      # エラーにはしない
      # TODO: loggerに差し替え
      puts "[DslLoader][warn] driver\"#{name}\"は既に登録されています"
      @__driver__ = drivers.first
    end
    @__driver__
  end

  def on(event_type_name, options = {}, &block)
    handlers = @__driver__.handlers.where(:event_type_names => [event_type_name.to_s])
    handlers.each do |handler|
      # TODO: loggerに差し替え
      puts "[DslLoader][warn] driver\"#{@__driver__.name}\"には、event_type_name\"#{event_type_name}\"が既に登録されています"
    end if handlers.count > 0
    @__driver__.handlers.new(:event_type_names => [event_type_name.to_s])
  end
end



