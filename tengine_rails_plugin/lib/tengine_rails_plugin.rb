require 'mongoid'
require 'rails'

module TengineRailsPlugin
  class Delayed
    include Mongoid::Document
    field :result, type: Hash, default: nil # arbitrary JSON

    def finished?
      self.class.exists?(conditions: { _id: _id, :result.exists => true })
    end
  end

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
      expandpath app, "event_sender.yml" do |yml|
        Tengine::Event.default_sender = Tengine::Event.parse(yml)
      end
      expandpath app, "mongoid.yml" do |yml|
        Mongoid.load! yml
      end
    end
  end

  def self.fire cmd, *argv
    doc = Delayed.create
    Tengine::Event.fire :delayed, properties: {
      delayed: doc._id,
      cmd: cmd,
      argv: argv,
    }
    return doc
  end
end
