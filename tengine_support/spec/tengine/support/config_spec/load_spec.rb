# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

require 'tengine/support/yaml_with_erb'

describe "config" do
  shared_examples_for "load_spec_01.yml's data common" do
    describe "accessors" do
      it { subject.action.should == "start"}
      it { subject.config.should == nil}
      it { subject.process.should be_a(App1::ProcessConfig) }
      it { subject.process.daemon.should == true}
      it { subject.process.pid_dir.should == "./tmp/pids"}
      it { subject.event_queue.connection.host.should == "rabbitmq1"}
      it { subject.event_queue.connection.port.should == 5672}
      it { subject.event_queue.exchange.name.should == "tengine_event_exchange"}
      it { subject.event_queue.exchange.type.should == 'direct'}
      it { subject.event_queue.exchange.durable.should == true}
      it { subject.event_queue.queue.name.should == "tengine_event_queue"}
      it { subject.event_queue.queue.durable.should == true}
      it { subject.log_common.output.should == "STDOUT"}
      it { subject.log_common.rotation.should == 5}
      it { subject.log_common.rotation_size.should == 1024 * 1024 * 1024}
      it { subject.log_common.level.should == "info"}
      it { subject.application_log.output.should == "log/application.log"}
      it { subject.application_log.rotation.should == 'daily'}
      it { subject.application_log.rotation_size.should == 1024 * 1024 * 1024}
      it { subject.application_log.level.should == "debug"}
      it { subject.process_stdout_log.output.should == "log/stdout.log"}
      it { subject.process_stdout_log.rotation.should == 5}
      it { subject.process_stdout_log.rotation_size.should == 1024 * 1024 * 1024}
      it { subject.process_stdout_log.level.should == "warn"}
      it { subject.process_stderr_log.output.should == "log/stderr.log"}
      it { subject.process_stderr_log.rotation.should == 5}
      it { subject.process_stderr_log.rotation_size.should == 1024 * 1024 * 1024}
      it { subject.process_stderr_log.level.should == "info"}
    end

    describe "like Hash" do
      it { subject[:action].should == "start"}
      it { subject[:config].should == nil}
      it { subject[:process].should be_a(App1::ProcessConfig) }
      it { subject[:process][:daemon].should == true}
      it { subject[:process][:pid_dir].should == "./tmp/pids"}
      it { subject[:event_queue][:connection][:host].should == "rabbitmq1"}
      it { subject[:event_queue][:connection][:port].should == 5672}
      it { subject[:event_queue][:exchange][:name].should == "tengine_event_exchange"}
      it { subject[:event_queue][:exchange][:type].should == 'direct'}
      it { subject[:event_queue][:exchange][:durable].should == true}
      it { subject[:event_queue][:queue][:name].should == "tengine_event_queue"}
      it { subject[:event_queue][:queue][:durable].should == true}
      it { subject[:log_common][:output].should == "STDOUT"}
      it { subject[:log_common][:rotation].should == 5}
      it { subject[:log_common][:rotation_size].should == 1024 * 1024 * 1024}
      it { subject[:log_common][:level].should == "info"}
      it { subject[:application_log][:output].should == "log/application.log"}
      it { subject[:application_log][:rotation].should == 'daily'}
      it { subject[:application_log][:rotation_size].should == 1024 * 1024 * 1024}
      it { subject[:application_log][:level].should == "debug"}
      it { subject[:process_stdout_log][:output].should == "log/stdout.log"}
      it { subject[:process_stdout_log][:rotation].should == 5}
      it { subject[:process_stdout_log][:rotation_size].should == 1024 * 1024 * 1024}
      it { subject[:process_stdout_log][:level].should == "warn"}
      it { subject[:process_stderr_log][:output].should == "log/stderr.log"}
      it { subject[:process_stderr_log][:rotation].should == 5}
      it { subject[:process_stderr_log][:rotation_size].should == 1024 * 1024 * 1024}
      it { subject[:process_stderr_log][:level].should == "info"}
    end

    describe "process to_hash" do
      it do
        subject.event_queue.connection.to_hash.should == {
          :host => "rabbitmq1",
          :port => 5672,
          :vhost=>nil,
          :user=>nil,
          :pass=>nil,
          :heartbeat_interval=>0
        }
      end
    end
  end

  shared_examples_for "load_spec_01.yml's data with db config" do
    describe "accessors" do
      it { subject.db.should be_a(Tengine::Support::Config::Mongoid::Connection) }
      it { subject.db.host.should == "localhost"}
      it { subject.db.port.should == 27020}
      it { subject.db.username.should == nil}
      it { subject.db.password.should == nil}
      it { subject.db.database.should == "tengine_production"}
    end
  end

  shared_examples_for "load_spec_01.yml's data with db Hash" do
    describe "accessors" do
      it do
        subject.db.should == {
          'host'=> "localhost",
          'port' => 27020,
          'username' => nil,
          'password' => nil,
          'database' => "tengine_production"
        }
      end
    end
  end

  context "app1 setting" do
    describe :load do
      before(:all) do
        @suite = build_suite1
        @suite.load(YAML.load_file(File.expand_path('load_spec_01.yml.erb', File.dirname(__FILE__))))
      end
      subject{ @suite }
      it_should_behave_like "load_spec_01.yml's data common"
      it_should_behave_like "load_spec_01.yml's data with db config"
    end

    describe :load_file do
      context "normal" do
        before(:all) do
          @suite = build_suite1
          @suite.load_file(File.expand_path('load_spec_01.yml.erb', File.dirname(__FILE__)))
        end
        subject{ @suite }
        it_should_behave_like "load_spec_01.yml's data common"
        it_should_behave_like "load_spec_01.yml's data with db config"
      end

      context "accept other settings" do
        before(:all) do
          @suite = build_suite1
          @suite.load_file(File.expand_path('load_spec_01_with_other_settings.yml.erb', File.dirname(__FILE__)))
        end
        subject{ @suite }
        it_should_behave_like "load_spec_01.yml's data common"
        it_should_behave_like "load_spec_01.yml's data with db config"
      end

      describe "error for other settings" do
        before(:all) do
          @suite = build_suite2
        end
        it do
          begin
            @suite.load_file(File.expand_path('load_spec_01_with_other_settings.yml.erb', File.dirname(__FILE__)))
          rescue Exception => e
            e.message.should =~ /child not found for \"app[23]_settings\"/
          end
        end
      end
    end

    describe :load_file_by_suite3 do
      before(:all) do
        @suite = build_suite3
        @suite.load_file(File.expand_path('load_spec_01.yml.erb', File.dirname(__FILE__)))
      end
      subject{ @suite }
      it_should_behave_like "load_spec_01.yml's data common"
      it_should_behave_like "load_spec_01.yml's data with db Hash"
    end

    describe :load_file_by_suite3_with_filepath do
      before(:all) do
        @suite = build_suite3(File.expand_path('load_spec_01.yml.erb', File.dirname(__FILE__)))
      end
      subject{ @suite }
      it_should_behave_like "load_spec_01.yml's data common"
      it_should_behave_like "load_spec_01.yml's data with db Hash"
    end

    describe :load_file_by_suite3_with_hash do
      before(:all) do
        @suite = build_suite3(YAML.load_file(File.expand_path('load_spec_01.yml.erb', File.dirname(__FILE__))))
      end
      subject{ @suite }
      it_should_behave_like "load_spec_01.yml's data common"
      it_should_behave_like "load_spec_01.yml's data with db Hash"
    end


    context "set like a Hash" do
      before do
        @suite = build_suite1
        @suite.load_file(File.expand_path('load_spec_01.yml.erb', File.dirname(__FILE__)))
      end

      describe "#[]=" do
        it "set value to field" do
          @suite[:event_queue][:connection][:port] = 2765
          @suite[:event_queue][:connection][:port].should == 2765
        end

        it "set value to group" do
          event_queue = @suite[:event_queue]
          expect{
            event_queue[:connection] = :hoge
          }.to raise_error(ArgumentError, "can't replace :connection")
        end
      end
    end
  end

  context "hash for db settings" do
    describe :load do
      before(:all) do
        @suite = build_suite2
        @suite.load(YAML.load_file(File.expand_path('load_spec_02.yml.erb', File.dirname(__FILE__))))
      end
      subject{ @suite }
      it_should_behave_like "load_spec_01.yml's data common"
      it "should has a hash for db settings" do
        subject.db.should == {
          'hosts' => [['tgndb001', 27017], ['tgndb002', 27017], ['tgndb003', 27017]],
          'host' => 'localhost',
          'port' => 27017,
          'username' => nil,
          'password' => nil,
          'database' => 'tengine_production',
          'read_secondary' => false,
          'max_retries_on_connection_failure' => 3
        }
      end
    end

    describe :load_file do
      before(:all) do
        @suite = build_suite1
        @suite.load_file(File.expand_path('load_spec_01.yml.erb', File.dirname(__FILE__)))
      end
      subject{ @suite }
      it_should_behave_like "load_spec_01.yml's data common"
      it_should_behave_like "load_spec_01.yml's data with db config"
     end
  end

end
