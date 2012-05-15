# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "config" do
  describe :parse! do
    context "setting1" do
      shared_examples_for "common_data" do
        it { subject.action.should == 'start'}
        it { subject.config.should == nil}
        it { subject.process.should be_a(App1::ProcessConfig) }
        # it { subject.process.daemon.should == nil}
        it { subject.process.pid_dir.should == nil}
        it { subject.db.should be_a(Tengine::Support::Config::Mongoid::Connection) }
        it { subject.db.host.should == "mongo1"}
        # it { subject.db.port.should == 27017}
        it { subject.db.username.should == 'goku'}
        it { subject.db.password.should == 'ideyoshenlong'}
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
        it { subject.log_common.level.should == "debug"}
        # it { subject.application_log.output.should == "STDOUT"}
        it { subject.application_log.rotation.should == 3}
        it { subject.application_log.rotation_size.should == 1024 * 1024}
        it { subject.application_log.level.should == "debug"}
        # it { subject.process_stdout_log.output.should == "STDOUT"}
        it { subject.process_stdout_log.rotation.should == 3}
        it { subject.process_stdout_log.rotation_size.should == 1024 * 1024}
        it { subject.process_stdout_log.level.should == "info"}
        # it { subject.process_stderr_log.output.should == "STDOUT"}
        it { subject.process_stderr_log.rotation.should == 3}
        it { subject.process_stderr_log.rotation_size.should == 1024 * 1024}
        it { subject.process_stderr_log.level.should == "debug"}
      end

      shared_examples_for "data1" do
        it { subject.db.port.should == 27017}
        it { subject.process.daemon.should == nil}
        it { subject.application_log.output.should == "STDOUT"}
        it { subject.process_stdout_log.output.should == "STDOUT"}
        it { subject.process_stderr_log.output.should == "STDOUT"}
      end

      shared_examples_for "data2" do
        it { subject.db.port.should == 27020}
        it { subject.process.daemon.should == true}
        it { subject.application_log.output.should == "./log/application.log"}
        it { subject.process_stdout_log.output.should == "./log/suite_stdout.log"}
        it { subject.process_stderr_log.output.should == "./log/suite_stderr.log"}
      end

      context "use long option name" do
        before(:all) do
          @suite = build_suite1
          @suite.parse!(%w[--action=start --db-host=mongo1 --db-username=goku --db-password=ideyoshenlong --log-common-level=debug --process-stdout-log-level=info])
        end
        subject{ @suite }
        it_should_behave_like "common_data"
        it_should_behave_like "data1"
      end

      context "use short option name" do
        before(:all) do
          @suite = build_suite1
          @suite.parse!(%w[-k start -O mongo1 -U goku -S ideyoshenlong --log-common-level=debug --process-stdout-log-level=info])
        end
        subject{ @suite }
        it_should_behave_like "common_data"
        it_should_behave_like "data1"
      end

      context "field value specified" do
        context "long option name" do
          before(:all) do
            @suite = build_suite1
            @suite.parse!(%w[-k start -O mongo1 -U goku -S ideyoshenlong --log-common-level=debug --process-stdout-log-level=info] +
              %w[--process-daemon --db-port=27020])
          end
          subject{ @suite }
          it_should_behave_like "common_data"
          it_should_behave_like "data2"
        end

        context "short options name" do
          before(:all) do
            @suite = build_suite1
            @suite.parse!(%w[-k start -O mongo1 -U goku -S ideyoshenlong --log-common-level=debug --process-stdout-log-level=info] +
              %w[-D -P 27020])
          end
          subject{ @suite }
          it_should_behave_like "common_data"
          it_should_behave_like "data2"
        end
      end

      context "show help" do
        it do
          @suite = build_suite1
          STDOUT.should_receive(:puts).with(HELP_MESSAGE)
          expect{
            @suite.parse!(%w[--help])
          }.to raise_error(SystemExit)
        end
      end

    end

  end

end


HELP_MESSAGE = <<END_OF_HELP
Usage: config_test [-k action] [-f path_to_config]
         [-H db_host] [-P db_port] [-U db_user] [-S db_pass] [-B db_database]

    -k, --action=VAL                 test|load|start|enable|stop|force-stop|status|activate  default: "start"
    -f, --config=VAL                 path/to/config_file 

process:
    -D, --process-daemon             process works on background. 
        --process-pid-dir=VAL        path/to/dir for PID created. 

db:
    -O, --db-host=VAL                hostname to connect db.  default: "localhost"
    -P, --db-port=VAL                port to connect db.  default: 27017
    -U, --db-username=VAL            username to connect db. 
    -S, --db-password=VAL            password to connect db. 
        --db-database=VAL            database name to connect db.  default: "tengine_production"

log_common:
        --log-common-output=VAL      file path or "STDOUT" / "STDERR" / "NULL".  default: "STDOUT"
        --log-common-level=VAL       Logging severity threshold.  must be one of debug,info,warn,error,fatal default: "info"
        --log-common-progname=VAL    program name to include in log messages. 
        --log-common-datetime-format=VAL
                                     A string suitable for passing to strftime. 

application_log:
        --application-log-output=VAL file path or "STDOUT" / "STDERR" / "NULL". if daemon process then "./log/application.log" else "STDOUT" default: "STDOUT"
        --application-log-level=VAL  Logging severity threshold. value of --log-common-level must be one of debug,info,warn,error,fatal default: "info"
        --application-log-progname=VAL
                                     program name to include in log messages. 
        --application-log-datetime-format=VAL
                                     A string suitable for passing to strftime. 

process_stdout_log:
        --process-stdout-log-output=VAL
                                     file path or "STDOUT" / "STDERR" / "NULL". if daemon process then "./log/suite_stdout.log" else "STDOUT" default: "STDOUT"
        --process-stdout-log-level=VAL
                                     Logging severity threshold. value of --log-common-level must be one of debug,info,warn,error,fatal default: "info"
        --process-stdout-log-progname=VAL
                                     program name to include in log messages. 
        --process-stdout-log-datetime-format=VAL
                                     A string suitable for passing to strftime. 

process_stderr_log:
        --process-stderr-log-output=VAL
                                     file path or "STDOUT" / "STDERR" / "NULL". if daemon process then "./log/suite_stderr.log" else "STDOUT" default: "STDOUT"
        --process-stderr-log-level=VAL
                                     Logging severity threshold. value of --log-common-level must be one of debug,info,warn,error,fatal default: "info"
        --process-stderr-log-progname=VAL
                                     program name to include in log messages. 
        --process-stderr-log-datetime-format=VAL
                                     A string suitable for passing to strftime. 

General:
        --version                    show version 
        --dump-skelton               dump skelton of config 
        --help                       show this help message 
END_OF_HELP
