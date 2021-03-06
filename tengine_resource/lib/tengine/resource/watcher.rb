# -*- coding: utf-8 -*-
require 'daemons'
require 'mongoid'
require 'eventmachine'
require 'tengine/event'
require 'tengine/mq'
require 'tengine/resource/config'
require 'tengine/core/mongoid_fix'

class Tengine::Resource::Watcher

  class ConfigurationError < StandardError
  end

  attr_reader :config, :pid

  def initialize(argv = [])
    @config = Tengine::Resource::Config::Resource.parse(argv)
    @pid = sprintf("process:%s/%d", ENV["MM_SERVER_NAME"], Process.pid)
    @mq_config = config[:event_queue].to_hash
    @mq_config[:sender] = { :keep_connection => true }
    @daemonize_options = {
      :app_name => 'tengine_resource_watchd',
      :ARGV => [config[:action]],
      :ontop => !config[:process][:daemon],
      # :monitor => true,
      :multiple => true,
      :dir_mode => :normal,
      :dir => File.expand_path(config[:process][:pid_dir]),
    }

    # 必要なディレクトリの生成
    FileUtils.mkdir_p(File.expand_path(config[:process][:pid_dir]))

    Tengine::Core::MethodTraceable.disabled = !config[:verbose]
  rescue Exception
    puts "[#{$!.class.name}] #{$!.message}\n  " << $!.backtrace.join("\n  ")
    raise
  end

  def mq_suite
    @mq_suite ||= Tengine::Mq::Suite.new(@mq_config)
    Tengine::Event.mq_suite = @mq_suite
  end

  def sender
    @sender ||= Tengine::Event::Sender.new(mq_suite)
    Tengine::Event.default_sender = @sender
  end

  def run(__file__)
    case config[:action].to_sym
    when :start
      start_daemon(__file__)
    when :stop
      stop_daemon(__file__)
    when :restart
      stop_daemon(__file__)
      start_daemon(__file__)
    end
  end

  def start_daemon(__file__)
    fname = File.basename __file__
    cwd = Dir.getwd
    Daemons.run_proc(fname, @daemonize_options) do
      Dir.chdir(cwd) { self.start }
    end
  end

  def stop_daemon(__file__)
    fname = File.basename __file__
    Daemons.run_proc(fname, @daemonize_options)
  end

  def start
    @config.setup_loggers
    # observerの登録
    Mongoid.observers = Tengine::Resource::Observer
    Mongoid.instantiate_observers

    Mongoid.configure do |c|
      c.send :load_configuration, @config[:db]
    end

    EM.run do
      sender.wait_for_connection do
        providers = find_providers
        providers.each do |provider|
          provider.retry_on_error = true if provider.respond_to?(:retry_on_error=)
          # polling_intervalが 0 以下の場合は、問い合わせを行わない
          if (polling_interval = provider.polling_interval) > 0
            # 仮想サーバタイプの監視
            provider.synchronize_virtual_server_types
            name = "#{provider.name}@#{self.class}"
            # Tengine::Core::Mutexをnameに対して固有のObjectIdを設定します。
            Tengine::Core::Mutex::Mutex.add_static_bson_objectid(name, provider.id)
            mutex = Tengine::Core::Mutex.new(name, provider.polling_interval)
            @periodic = EM.add_periodic_timer(provider.polling_interval) do
              mutex.synchronize do
                # 物理サーバの監視
                provider.synchronize_physical_servers
                mutex.heartbeat
                # 仮想サーバの監視
                provider.synchronize_virtual_servers
                mutex.heartbeat
                # 仮想サーバイメージの監視
                provider.synchronize_virtual_server_images
              end
            end
          end
        end
      end
    end
  end

  def shutdown
    EM.run do
      EM.cancel_timer @periodic if @periodic
      sender.stop
    end
  end

  def find_providers
    providers = Tengine::Resource::Provider.all
    begin
      result = providers.to_a
      raise ConfigurationError, "no provider found" if result.empty?
      return result
    rescue NameError => e
      raise e unless e.message =~ /uninitialized constant/
      documents = Mongoid.default_session.collections.
        detect{|c| c.name.to_s == Tengine::Resource::Provider.collection_name.to_s}.find
      types = documents.map{|d| d['_type']}
      undefined_type_names = types.select do |t|
        begin
          t.constantize
          false
        rescue Exception
          true
        end
      end
      raise ConfigurationError, "provider class not found: " << undefined_type_names.join(", ")
    end
  end


  extend Tengine::Core::MethodTraceable
  method_trace(*instance_methods(false))

end
