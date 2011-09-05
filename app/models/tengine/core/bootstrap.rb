# -*- coding: utf-8 -*-

class Tengine::Core::Bootstrap

  attr_reader :options

  def initialize(opt)
    @options = opt
  end

  def boot
    case options[:action]
    when "load" then load_dsl
    when "start"
      load_dsl if options[:boot_options] == []
      start_kernel
    when "test"
      load_dsl
      start_kernel
    when "enable" then enable_drivers
    end
  end

  def load_dsl
  end

  def start_kernel
  end

  def enable_drivers
  end

  def self.default_options
    @default_options ||= {
      :action                 => "start",
      :daemon                 => false,
      :boot_options           => [],
      :tengine_log_dir        => ".",
      :tengine_pid_dir        => "./tmp/tengined_pids",
      :tengine_activation_dir => "./tmp/tengined_activations",
      :db_host                => "localhost",
      :db_port                => 27017,
      :db_database            => "tengine_production",
      :mq_conn_host           => "localhost",
      :mq_conn_port           => 5672,
      :mq_exchange_name       => "tengine_event_exchange",
      :mq_exchange_type       => "direct",
      :mq_exchange_durable    => true,
      :mq_queue_name          => "tengine_event_queue",
      :mq_queue_durable       => true,
      :mq_pub_persistent      => true,
      :mq_pub_mandatory       => false
    }
  end

end
