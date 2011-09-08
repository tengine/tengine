# -*- coding: utf-8 -*-
require 'tengine/event'
require 'tengine/mq'
require 'eventmachine'

class Tengine::Core::Bootstrap

  attr_accessor :config
  attr_accessor :kernel

  def initialize(hash)
    @config = Tengine::Core::Config[hash]
    prepare_trap
  end

  def prepare_trap; Signal.trap(:HUP) {puts ":HUP"; kernel.stop} end

  def boot
    case config[:action]
    when "load" then load_dsl
    when "start"
      load_dsl unless config[:tengined][:skip_load]
      start_kernel
    when "test"
      config[:tengined][:skip_waiting_activation] = true
      config[:tengined][:load_path] = File.expand_path("../../../../lib/tengine/core/connection_test/fire_bar_on_foo.rb", File.dirname(__FILE__))

      # VERSIONファイルの生成とバージョンアップの書き込み
      version_file = File.open("#{config.dsl_dir_path}/VERSION", "w")
      version_file.write(Time.now.strftime("%Y%m%d%H%M%S").to_s)
      version_file.close

      load_dsl
      start_kernel
      start_connection_test
      stop_kernel
    when "enable" then enable_drivers
    when "status" then kernel_status
    else
      raise ArgumentError, "config[:action] in boot method must be test|load|start|enable|status but was #{config[:action]} "
    end
  end

  def load_dsl
    obj = Tengine::Core::DslDummyEnv.new
    obj.extend(Tengine::Core::DslLoader)
    obj.config = config
    obj.evaluate
  end

  def start_kernel
    @kernel ||= Tengine::Core::Kernel.new(config)
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
    EM.run do
      event_type_name = :foo
      options = { :notification_level_key => :info }
      Tengine::Event.config = {
        :connection => config[:event_queue][:connection],
        :exchange => config[:event_queue][:exchange],
        :queue => config[:event_queue][:queue]
      }
      Tengine::Event.fire(event_type_name, options) do
        Tengine::Event.mq_suite.connection.disconnect { EM.stop }
      end
    end
  end

  # 自動でログ出力する
  extend Tengine::Core::MethodTraceable
  method_trace(:prepare_trap, :boot, :load_dsl, :start_kernel, :stop_kernel,
    :enable_drivers, :kernel_status, :start_connection_test)

end

# SIGINTをトラップして、stop_kernelする必要あり
