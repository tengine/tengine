# -*- coding: utf-8 -*-
def build_suite1
  Tengine::Support::Config.suite do
    banner <<EOS
Usage: config_test [-k action] [-f path_to_config]
         [-H db_host] [-P db_port] [-U db_user] [-S db_pass] [-B db_database]

EOS

    field(:action, "test|load|start|enable|stop|force-stop|status|activate", :type => :string, :default => "start")
    load_config(:config, "path/to/config_file", :type => :string)
    add(:process, App1::ProcessConfig)
    add(:db, Tengine::Support::Config::Mongoid::Connection, :defaults => {:database => "tengine_production"})
    group(:event_queue, :hidden => true) do
      add(:connection, Tengine::Support::Config::Amqp::Connection)
      add(:exchange  , Tengine::Support::Config::Amqp::Exchange, :defaults => {:name => 'tengine_event_exchange'})
      add(:queue     , Tengine::Support::Config::Amqp::Queue   , :defaults => {:name => 'tengine_event_queue'})
    end
    hide_about_rotation = proc do
      find(:rotation).hidden = true; find(:rotation_size).hidden = true
    end
    add(:log_common, Tengine::Support::Config::Logger,
      :defaults => {
        :rotation      => 3          ,
        :rotation_size => 1024 * 1024,
        :level         => 'info'     ,
      }, &hide_about_rotation)
    add(:application_log, App1::LoggerConfig,
      :parameters => { :logger_name => "application" },
      :dependencies => { :process_config => :process, :log_common => :log_common,}, &hide_about_rotation)
    add(:process_stdout_log, App1::LoggerConfig,
      :parameters => { :logger_name => proc{ "#{File.basename(__FILE__, '.*')}_stdout"} },
      :dependencies => { :process_config => :process, :log_common => :log_common,}, &hide_about_rotation)
    add(:process_stderr_log, App1::LoggerConfig,
      :parameters => { :logger_name => "#{File.basename(__FILE__, '.*')}_stderr" },
      :dependencies => { :process_config => :process, :log_common => :log_common,}, &hide_about_rotation)
    ignore(:app2_settings, :app3_settings)
    separator("\nGeneral:")
    __action__(:version, "show version"){ STDOUT.puts "1.1.1"; exit }
    __action__(:dump_skelton, "dump skelton of config"){ STDOUT.puts YAML.dump(root.to_hash); exit }
    __action__(:help   , "show this help message"){ STDOUT.puts option_parser.help; exit }

    mapping({
        [:action] => :k,
        [:config] => :f,
        [:process, :daemon] => :D,
        [:db, :host] => :O,
        [:db, :port] => :P,
        [:db, :username] => :U,
        [:db, :password] => :S,
      })
  end

end

# build_suite1 との違いは、:dbが Tengine::Support::Config::Mongoid::Connectionではなくて、
# 単なるhashのfieldとして定義している点と ignore(:app2_settings, :app3_settings) の定義がない点です。
def build_suite2
  Tengine::Support::Config.suite do
    banner <<EOS
Usage: config_test [-k action] [-f path_to_config]
         [-H db_host] [-P db_port] [-U db_user] [-S db_pass] [-B db_database]

EOS

    field(:action, "test|load|start|enable|stop|force-stop|status|activate", :type => :string, :default => "start")
    load_config(:config, "path/to/config_file", :type => :string)
    add(:process, App1::ProcessConfig)
    field(:db, "settings to connect to db", :type => :hash, :default => {
        :host => 'localhost',
        :port => 27017,
        :username => nil,
        :password => nil,
        :database => 'tengine_production',
      })
    group(:event_queue, :hidden => true) do
      add(:connection, Tengine::Support::Config::Amqp::Connection)
      add(:exchange  , Tengine::Support::Config::Amqp::Exchange, :defaults => {:name => 'tengine_event_exchange'})
      add(:queue     , Tengine::Support::Config::Amqp::Queue   , :defaults => {:name => 'tengine_event_queue'})
    end
    add(:log_common, Tengine::Support::Config::Logger,
      :defaults => {
        :rotation      => 3          ,
        :rotation_size => 1024 * 1024,
        :level         => 'info'     ,
      })
    add(:application_log, App1::LoggerConfig,
      :logger_name => "application",
      :dependencies => { :process_config => :process, :log_common => :log_common,})
    add(:process_stdout_log, App1::LoggerConfig,
      :logger_name => "#{File.basename($PROGRAM_NAME)}_stdout",
      :dependencies => { :process_config => :process, :log_common => :log_common,})
    add(:process_stderr_log, App1::LoggerConfig,
      :logger_name => "#{File.basename($PROGRAM_NAME)}_stderr",
      :dependencies => { :process_config => :process, :log_common => :log_common,})
    separator("\nGeneral:")
    __action__(:version, "show version"){ STDOUT.puts "1.1.1"; exit }
    __action__(:dump_skelton, "dump skelton of config"){ STDOUT.puts YAML.dump(root.to_hash); exit }
    __action__(:help   , "show this help message"){ STDOUT.puts option_parser.help; exit }

    mapping({
        [:action] => :k,
        [:config] => :f,
        [:process, :daemon] => :D,
        [:db, :host] => :O,
        [:db, :port] => :P,
        [:db, :username] => :U,
        [:db, :password] => :S,
      })
  end

end




# build_suite2 との違いは、Tengine::Support::Config::Definition::Suiteを直接newするのではなく
# 継承したものをnewしている点です。それ以外は変わりません
def build_suite3(*args)
  ConfigSuite3.new(*args)
end

class ConfigSuite3 < Tengine::Support::Config::Definition::Suite
  def build
    banner <<EOS
Usage: config_test [-k action] [-f path_to_config]
         [-H db_host] [-P db_port] [-U db_user] [-S db_pass] [-B db_database]

EOS

    field(:action, "test|load|start|enable|stop|force-stop|status|activate", :type => :string, :default => "start")
    load_config(:config, "path/to/config_file", :type => :string)
    add(:process, App1::ProcessConfig)
    # field(:db, "settings to connect to db", :type => :hash,
    #   :default => {:database => "tengine_production"})
    field(:db, "settings to connect to db", :type => :hash, :default => {
        :host => 'localhost',
        :port => 27017,
        :username => nil,
        :password => nil,
        :database => 'tengine_production',
      })
    group(:event_queue, :hidden => true) do
      add(:connection, Tengine::Support::Config::Amqp::Connection)
      add(:exchange  , Tengine::Support::Config::Amqp::Exchange, :defaults => {:name => 'tengine_event_exchange'})
      add(:queue     , Tengine::Support::Config::Amqp::Queue   , :defaults => {:name => 'tengine_event_queue'})
    end
    hide_about_rotation = proc do
      find(:rotation).hidden = true; find(:rotation_size).hidden = true
    end
    add(:log_common, Tengine::Support::Config::Logger,
      :defaults => {
        :rotation      => 3          ,
        :rotation_size => 1024 * 1024,
        :level         => 'info'     ,
      }, &hide_about_rotation)
    add(:application_log, App1::LoggerConfig,
      :logger_name => "application",
      :dependencies => { :process_config => :process, :log_common => :log_common,}, &hide_about_rotation)
    add(:process_stdout_log, App1::LoggerConfig,
      :logger_name => "#{File.basename($PROGRAM_NAME)}_stdout",
      :dependencies => { :process_config => :process, :log_common => :log_common,}, &hide_about_rotation)
    add(:process_stderr_log, App1::LoggerConfig,
      :logger_name => "#{File.basename($PROGRAM_NAME)}_stderr",
      :dependencies => { :process_config => :process, :log_common => :log_common,}, &hide_about_rotation)
    separator("\nGeneral:")
    __action__(:version, "show version"){ STDOUT.puts "1.1.1"; exit }
    __action__(:dump_skelton, "dump skelton of config"){ STDOUT.puts YAML.dump(root.to_hash); exit }
    __action__(:help   , "show this help message"){ STDOUT.puts option_parser.help; exit }

    mapping({
        [:action] => :k,
        [:config] => :f,
        [:process, :daemon] => :D,
        [:db, :host] => :O,
        [:db, :port] => :P,
        [:db, :username] => :U,
        [:db, :password] => :S,
      })

  end
end
