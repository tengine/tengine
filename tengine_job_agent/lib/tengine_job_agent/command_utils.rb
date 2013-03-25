# -*- coding: utf-8 -*-
require 'tengine_event'
require 'tengine_job_agent'
require 'time'
require 'logger'
require 'yaml'
require 'tengine/support/yaml_with_erb'

require 'eventmachine'

module TengineJobAgent::CommandUtils
  def self.included(mod)
    mod.extend(ClassMethods)
  end

  class TitledLogger < Logger
    attr_reader :title
    def initialize(title, *args, &block)
      super(*args, &block)
      @title = title
    end
    %w[debug info warn error fatal].each do |level|
      class_eval(<<-END_OF_METHOD)
        def #{level}(progname = nil, &block)
          super("[\#{title}] \#{progname}", &block)
        end
      END_OF_METHOD
    end
  end

  DEFAULT_CONFIG = {
    'timeout' => 1,
    # 'logfile' => "log/#{File.basename($PROGRAM_NAME)}-#{`hostname`.strip}-#{Process.pid}.log",
    'logfile' => "#{File.basename($PROGRAM_NAME)}.log",
    # 'logfile' => "tengine_job_agent.log",
    'connection' => {
      'host' => ENV['TENGINE_MQ_HOST'] || 'localhost',
      'port' => (ENV['TENGINE_MQ_PORT'] || 5672).to_i,
      # vhost:
      # user:
      # pass:
    },
    'exchange' => {
      'name' => 'tengine_event_exchange',
      'type' => 'direct',
      'durable' => true,
    },
    'sender' => {
        'keep_connection' => true,
    },
    'heartbeat' => {
      'job' => {
        'interval' => 1
      }
    }
  }.freeze

  module ClassMethods
    def load_config
      config_path = Dir["{.,./config,/etc}/tengine_job_agent{.yml,.yml.erb}"].first
      if config_path
        YAML.load_file(config_path)
      else
        DEFAULT_CONFIG
      end
    end

    def process(*args)
      config = load_config
      logger = new_logger(config)
      Tengine.logger = logger
      Kernel.at_exit do
        logger.info("process is exiting now")
      end

      begin
        logger.info("#{self.name}#process starting")
        new(logger, args, config).process
        logger.info("#{self.name}#process finished successfully")
      rescue Exception => e
        logger.error("#{self.name}#process error: [#{e.class.name}] #{e.message}\n  " << e.backtrace.join("\n"))
        return false
      ensure
        logger.info("#{self.name}#process finished at the end")
      end
    end

    LOG_FORMAT = "\e[%dm[%s #%5d %5s] %5s %s\n\e[0m".freeze

    def thread_name(tid = Thread.current.object_id, name = nil)
      result = @thread_names[tid]
      return result if result
      @mutex ||= Mutex.new
      @mutex.lock
      begin
        name ||= (@thread_names.length + 1).to_s
        @thread_names[tid] = name[0,5]
        return name
      ensure
        @mutex.unlock
      end
    end

    def new_logger(config)
      @thread_names ||= {}
      thread_name(Thread.main.object_id, "MAIN")
      unless Thread.current.object_id == Thread.main.object_id
        thread_name(Thread.current.object_id, "BASE")
      end
      thread_name(EM.reactor_thread.object_id, "EM_RA")

      logfile = config['logfile']
      unless logfile
        prefix = self.name.split('::').last.downcase
        logfile = File.expand_path("#{prefix}-#{Process.pid}.log", config['log_dir'])
      end
      result = TitledLogger.new(File.basename($PROGRAM_NAME), logfile)
      result.formatter = lambda do |severity, datetime, progname, message|
        tn = thread_name
        margin = 3
        no = (tn =~ /^\d+$/) ? tn.to_i : margin
        # http://d.hatena.ne.jp/keyesberry/20101107/p1
        color_no = 37 + margin - no
        LOG_FORMAT % [color_no, datetime.iso8601(6), Process.pid, tn, severity, message]
      end
      result.level = Logger::DEBUG
      result
    end

  end
end
