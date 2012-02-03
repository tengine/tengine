# -*- coding: utf-8 -*- 
#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

TengineConsole::Application.load_tasks

require File.expand_path('../config/end_to_end_test', __FILE__)

desc "wait for dependencies"
task:check do

  RETRIES = 10
  SLEEP = 30

  require 'bundler/setup'
  require 'tengine/support/core_ext/hash/keys'
  require 'amqp'
  require 'mongoid/railtie'
  require 'syslog'
  Syslog.open 'local7' # boot.log

  # RabbitMQ読み込み
  begin
    c = YAML.load_file './config/event_sender.yml.erb'
    c.deep_symbolize_keys!
    EM.run do
      AMQP.connect c[:connection] do |d|
        d.disconnect do
          EM.stop
        end
      end
    end
  rescue AMQP::TCPConnectionFailed => e
    Syslog.err e.message
    EM.stop if EM.reactor_running?
    sleep 1
    retry
  end
  Syslog.info "(1/2) OK, AMQP is up."

  # Mongoid読み込み
  begin
    Mongoid.load! './config/mongoid.yml'
  rescue Mongo::ConnectionFailure => e
    Syslog.err e.message
    sleep 1
    retry
  end
  Syslog.info "(2/2) OK, Mongoid is up."
end
