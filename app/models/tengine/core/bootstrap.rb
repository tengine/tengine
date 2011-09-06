# -*- coding: utf-8 -*-

class Tengine::Core::Bootstrap

  attr_reader :config

  def initialize(hash)
    @config = Tengine::Core::Config.new(hash)
  end

  def boot
    case config[:action]
    when "load" then load_dsl
    when "start"
      load_dsl unless config[:tengined][:prevent_loader] == true
      start_kernel
    when "test"
      load_dsl
      start_kernel
      start_connection_test
      stop_kernel
    when "enable" then enable_drivers
    end
  end

  def load_dsl
    obj = Tengine::Core::DslDummyEnv.new
    obj.extend(Tengine::Core::DslLoader)
    obj.config = config
    obj.evaluate
  end

  def start_kernel
    kernel = Tengine::Core::Kernel.new(config)
    kernel.start
  end

  def stop_kernel
  end

  def enable_drivers
  end

  def start_connection_test
  end
end
