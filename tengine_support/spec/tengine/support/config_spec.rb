# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "config" do

  context "app1 setting" do
    context "static" do

      describe App1::ProcessConfig.daemon do
        it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
        its(:type){ should == :boolean }
        its(:__name__){ should == :daemon }
        its(:description){ should == 'process works on background.'}
        its(:default){ should == nil}
      end

      describe App1::ProcessConfig.pid_dir do
        it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
        its(:type){ should == :directory }
        its(:__name__){ should == :pid_dir }
        its(:description){ should == 'path/to/dir for PID created.'}
        its(:default){ should == nil}
      end
    end

    context "dynamic" do
      before(:all) do
        @suite = build_suite1
      end

      subject do
        @suite
      end

      describe "accessors" do
        it { subject.action.should == "start"}
        it { subject.config.should == nil}
        it { subject.process.should be_a(App1::ProcessConfig) }
        it { subject.process.daemon.should == nil}
        it { subject.process.pid_dir.should == nil}
        it { subject.db.should be_a(Tengine::Support::Config::Mongoid::Connection) }
        it { subject.db.host.should == "localhost"}
        it { subject.db.port.should == 27017}
        it { subject.db.username.should == nil}
        it { subject.db.password.should == nil}
        it { subject.db.database.should == "tengine_production"}
        it { subject.event_queue.connection.host.should == "localhost"}
        it { subject.event_queue.connection.port.should == 5672}
        it { subject.event_queue.exchange.name.should == "tengine_event_exchange"}
        it { subject.event_queue.exchange.type.should == 'direct'}
        it { subject.event_queue.exchange.durable.should == true}
        it { subject.event_queue.queue.name.should == "tengine_event_queue"}
        it { subject.event_queue.queue.durable.should == true}
        it { subject.log_common.output.should == "STDOUT"}
        it { subject.log_common.rotation.should == 3}
        it { subject.log_common.rotation_size.should == 1024 * 1024}
        it { subject.log_common.level.should == "info"}
        it { subject.application_log.output.should == "STDOUT"}
        it { subject.application_log.rotation.should == 3}
        it { subject.application_log.rotation_size.should == 1024 * 1024}
        it { subject.application_log.level.should == "info"}
      end

      it :to_hash do
        subject.to_hash.should == {
          :action => 'start',
          :config => nil,
          :process => {
            :daemon => nil,
            :pid_dir => nil,
          },
          :db => {
            :host => 'localhost',
            :port => 27017,
            :username => nil,
            :password => nil,
            :database => 'tengine_production'
          },
          :event_queue => {
            :connection => {
              :host => 'localhost',
              :port => 5672,
              :vhost => nil,
              :user  => nil,
              :pass  => nil,
              :heartbeat_interval => 0,
            },
            :exchange => {
              :name => 'tengine_event_exchange',
              :type => 'direct',
              :durable => true,
            },
            :queue => {
              :name => 'tengine_event_queue',
              :durable => true,
            },
          },

          :log_common => {
            :output        => "STDOUT"   ,
            :rotation      => 3          ,
            :rotation_size => 1024 * 1024,
            :level         => 'info'     ,
            :progname => nil, :datetime_format => nil,
          }.freeze,

          :application_log => {
            :output        => "STDOUT",
            :rotation=>3, :rotation_size=>1048576, :level=>"info",
            :progname => nil, :datetime_format => nil,
          }.freeze,

          :process_stdout_log => {
            :output        => "STDOUT",
            :rotation=>3, :rotation_size=>1048576, :level=>"info",
            :progname => nil, :datetime_format => nil,
          }.freeze,

          :process_stderr_log => {
            :output        => "STDOUT",
            :rotation=>3, :rotation_size=>1048576, :level=>"info",
            :progname => nil, :datetime_format => nil,
          }.freeze,
        }
      end

      it "suite has children" do
        subject.children.map(&:__name__).should == [
          :action, :config,
          :process, :db, :event_queue, :log_common,
          :application_log, :process_stdout_log, :process_stderr_log, :separator10, :version, :dump_skelton, :help]
      end

      context "suite returns child by name" do
        {
          :process => App1::ProcessConfig,
          :db => Tengine::Support::Config::Mongoid::Connection,
          :event_queue => Tengine::Support::Config::Definition::Group,
          [:event_queue, :connection] => NilClass,
          [:event_queue, :exchange  ] => NilClass,
          [:event_queue, :queue     ] => NilClass,
          :log_common => Tengine::Support::Config::Logger,
          :application_log => App1::LoggerConfig,
          :process_stdout_log => App1::LoggerConfig,
          :process_stderr_log => App1::LoggerConfig,
        }.each do |name, klass|
          it{ subject.child_by_name(name).should be_a(klass) }
        end

        {
          :process => App1::ProcessConfig,
          :db => Tengine::Support::Config::Mongoid::Connection,
          :event_queue => Tengine::Support::Config::Definition::Group,
          [:event_queue, :connection] => Tengine::Support::Config::Amqp::Connection,
          [:event_queue, :exchange  ] => Tengine::Support::Config::Amqp::Exchange,
          [:event_queue, :queue     ] => Tengine::Support::Config::Amqp::Queue,
          :log_common => Tengine::Support::Config::Logger,
          :application_log => App1::LoggerConfig,
          :process_stdout_log => App1::LoggerConfig,
          :process_stderr_log => App1::LoggerConfig,
        }.each do |name_array, klass|
          it{ subject.find(name_array).should be_a(klass) }
        end
      end

      context "parent and children" do
        it do
          log_common = subject.find(:log_common)
          application_log = subject.find(:application_log)
          log_common.should_not == application_log
          log_common.children.each do |log_common_child|
            application_log_child = application_log.child_by_name(log_common_child.__name__)
            application_log_child.should_not be_nil
            application_log_child.__name__.should == log_common_child.__name__
            application_log_child.object_id.should_not == log_common_child.object_id
            application_log_child.__parent__.should == application_log
            log_common_child.__parent__.should == log_common
          end
        end
      end

      context "dependencies" do
        it do
          application_log = subject.find(:application_log)
          application_log.process_config.should_not be_nil
          application_log.process_config.should be_a(App1::ProcessConfig)
          application_log.log_common.should_not be_nil
          application_log.log_common.should be_a(Tengine::Support::Config::Logger)
        end
      end

      context "parameters" do
        it{ subject.application_log.logger_name.should == "application" }
        it{ subject.process_stdout_log.logger_name.should == "suite_stdout" }
        it{ subject.process_stderr_log.logger_name.should == "suite_stderr" }
      end

    end
  end

  describe ConfigSuite3 do
    context "instance" do
      subject{ ConfigSuite3.new }

      it "ログの出力先のデフォルト値" do
        subject.application_log.output.should == "STDOUT"
      end

      it "明示的にnilを設定してもデフォルト値が得られる" do
        subject.application_log.output = nil
        subject.application_log.output.should == "STDOUT"
      end

    end
  end

end
