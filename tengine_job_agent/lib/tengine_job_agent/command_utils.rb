require 'tengine_job_agent'
require 'logger'
require 'yaml'
require 'tengine/support/yaml_with_erb'

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
    'logfile' => "tengine_job_agent.log",
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
      result = TitledLogger.new(File.basename($PROGRAM_NAME), logfile)
      result.level = Logger::DEBUG
      result
    end

  end
end
