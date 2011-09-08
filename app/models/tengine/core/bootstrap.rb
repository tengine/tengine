# -*- coding: utf-8 -*-

class Tengine::Core::Bootstrap

  attr_accessor :config
  attr_accessor :kernel

  def initialize(hash)
    @config = Tengine::Core::Config.new(hash)
  end

  def boot
    case config[:action]
    when "load" then load_dsl
    when "start"
      load_dsl unless config[:tengined][:skip_load] == true
      start_kernel
    when "test"
      # TODO 接続テスト用イベントハンドラ定義ファイルをload_pathに指定してあげる必要があります
      # config[:tengined][:load_path] = File.expand_path("../../../../lib/tengine/core/connection_test/fire_bar_on_foo.rb", __FILE__)
      # @config[:tengined][:load_path] = tengine_coreのルート/lib/tengine/core/connection_test/fire_bar_on_foo.rb
      # tengine_coreのルート/lib/tengine/core/connection_test/VERSION
      load_dsl
      start_kernel
      start_connection_test
      stop_kernel
    when "enable" then enable_drivers
    when "status" then kernel_status
    when "stop" then stop_kernel
    else
      raise ArgumentError, "config[:action] must be test|load|start|enable|stop|force-stop|status but was #{config[:action]} "
    end
  end

  def load_dsl
    obj = Tengine::Core::DslDummyEnv.new
    obj.extend(Tengine::Core::DslLoader)
    obj.config = config
    obj.evaluate
  end

  def start_kernel
    @kernel = Tengine::Core::Kernel.new(config)
    kernel.start
  end

  def stop_kernel
    kernel.stop
  end

  def enable_drivers
    drivers = Tengine::Core::Driver.where(:version => config.dsl_version, :enabled_on_activation => false)
    drivers.each{ |d| d.update_attribute(:enabled, true) }
  end

  def kernel_status
  end

  def start_connection_test
    event_type_name = :foo
    options = { :notification_level_key => :info }
    Tengine::Event.config = {
      :connection => config[:event_queue][:connection],
      :exchange => config[:event_queue][:exchange],
      :queue => config[:event_queue][:queue]
    }
    Tengine::Event.fire(event_type_name, options)
  end
end
