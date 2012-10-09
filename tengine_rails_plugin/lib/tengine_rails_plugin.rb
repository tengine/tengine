require 'rails'

module TengineRailsPlugin
  class Railtie < Rails::Railtie
    def expandpath app, str
      app.paths["config"].expanded.each do |d|
        yml = File.expand_path(str, d)
        if File.exist?(yml)
          yield yml
        else
          str = "#{yml} not found, write one please."
          Rails.logger.error(str)
          STDERR.puts(str) if STDERR.isatty
        end
      end
    end

    initializer "newplugin.initialize" do |app|
      require 'tengine_event'
      require 'tengine/support/yaml_with_erb'
      expandpath app, "event_sender.yml" do |yml|
        Tengine::Event.config = YAML.load_file(yml)
      end
    end
  end
end
