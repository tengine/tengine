# -*- coding: utf-8 -*-
require 'tengine/resource/cli'

module Tengine::Resource::CLI::GlobalOptions

  def self.included(mod)
    mod.extend(ClassMethods)
  end

  def load_config
    require 'tengine_resource'
    @config = Tengine::Resource::Config::Resource.new.tap do |c|
      if path = options[:config]
        c.load_file(path)
      else
        c.load({:db => Tengine::Core::Config::DB::DEFAULT_SETTINGS})
      end
    end
  end

  def config_mongoid
    load_config
    require 'mongoid'
    Mongoid.configure do |c|
      c.send :load_configuration, @config[:db]
    end
  end

  module ClassMethods
    def self.extended(obj)
      obj.instance_eval do
        alias :desc_without_global_options :desc
        alias :desc :desc_with_global_options
      end
    end

    def desc_with_global_options(*args, &block)
      res = desc_without_global_options(*args, &block)
      config_file
      res
    end

    def config_file
      method_option :config, :type => :string, :aliases => "-f", :desc => "config to connect MongoDB as same as tengine_resource_watcher's config"
    end
  end
end
