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

    def new_logger(config)
      logfile = config['logfile']
      unless logfile
        prefix = self.name.split('::').last.downcase
        logfile = File.expand_path("#{prefix}-#{Process.pid}.log", config['log_dir'])
      end
      result = Tengine::Support::NamedLogger.new(File.basename($PROGRAM_NAME), logfile)
      result.level = Logger::DEBUG
      result
    end

  end
end
