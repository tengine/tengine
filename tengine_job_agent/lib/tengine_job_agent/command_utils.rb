require 'tengine_job_agent'
require 'logger'
require 'yaml'
require 'tengine/support/yaml_with_erb'

module TengineJobAgent::CommandUtils
  def self.included(mod)
    mod.extend(ClassMethods)
  end

  module ClassMethods
    def load_config
      config_path = Dir["{.,./config,/etc}/tengine_job_agent{.yml,.yml.erb}"].first
      YAML.load_file(config_path)
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
