require 'tengine_job_agent'
require 'logger'
require 'yaml'
require 'tengine/support/yaml_with_erb'

module TengineJobAgent::CommandUtils
  def self.included(mod)
    mod.extend(ClassMethods)
  end

  DEFAULT_CONFIG = {
    'timeout' => 1,
    # 'logfile' => "log/#{File.basename($PROGRAM_NAME)}-#{`hostname`.strip}-#{Process.pid}.log",
    'logfile' => "tengine_job_agent.log",
    'connection' => {
      'host' => 'localhost',
      'port' => 5672,
      # vhost:
      # user:
      # pass:
    },
    'exchange' => {
      'name' => 'tengine_event_exchange',
      'type' => 'direct',
      'durable' => true,
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
      begin
        return new(logger, args, config).process
      rescue Exception => e
        logger.error("error: [#{e.class.name}] #{e.message}\n  " << e.backtrace.join("\n"))
        return false
      end
    end

    def new_logger(config)
      logfile = config['logfile']
      unless logfile
        prefix = self.name.split('::').last.downcase
        logfile = File.expand_path("#{prefix}-#{Process.pid}.log", config['log_dir'])
      end
      Logger.new(logfile)
    end

  end
end
