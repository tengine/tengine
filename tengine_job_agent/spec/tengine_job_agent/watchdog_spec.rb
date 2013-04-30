# -*- coding: utf-8 -*-
require 'spec_helper'
require 'amqp'

require 'timeout'

require 'yaml'
require 'tengine/support/yaml_with_erb'

describe TengineJobAgent::Watchdog do

  before do
    @log_buffer = StringIO.new
    @logger = Logger.new(@log_buffer)
    @config = YAML.load_file(File.expand_path("../config/tengine_job_agent.yml.erb",
                                              File.dirname(__FILE__)))
  end

  subject do
    @pid_path = "/dev/null"
    echo_foo = File.expand_path "../scripts/echo_foo.sh", __FILE__
    TengineJobAgent::Watchdog.new(@logger, [@pid_path, echo_foo], @config)
  end

  it { should_not be_nil }

  describe "#process" do
    let(:pid) { mock(Numeric.new) }
    let(:stat) { mock($?) }
    before do
      bigzero = (1 << 1024).coerce(0)[0]
      pid.stub(:to_int).and_return(bigzero)
      stat.stub(:exitstatus).and_return(bigzero)
    end

    it "spawnする" do
      subject.should_receive(:spawn_process).and_return(pid)
      subject.stub(:start_wait_process).with(pid).and_return(stat)
      subject.stub(:fire_finished).with(pid, stat)
      sender = mock(:sender)
      sender.stub_chain(:mq_suite, :ensures).with(:connection).and_yield
      subject.stub(:sender).and_return(sender)
      sender.stub(:wait_for_connection).and_yield
      EM.run do
        EM.add_timer(0.1) { EM.stop }
        subject.process
      end
    end

    it "子プロセスを待つ" do
      subject.stub(:spawn_process).and_return(pid)
      subject.should_receive(:start_wait_process).and_return(stat)
      subject.stub(:fire_finished).with(pid, stat)
      sender = mock(:sender)
      sender.stub_chain(:mq_suite, :ensures).with(:connection).and_yield
      subject.stub(:sender).and_return(sender)
      sender.stub(:wait_for_connection).and_yield
      EM.run do
        EM.add_timer(0.1) { EM.stop }
        subject.process
      end
    end

    context "ファイルへの出力" do
      before do
        @echo_foo = File.expand_path "../scripts/echo_foo.sh", __FILE__
        mock_stdout = mock(:stdout, :path => "/tmp/stdout")
        mock_stderr = mock(:stderr, :path => "/tmp/stderr")
        subject.should_receive(:with_tmp_outs).and_yield(mock_stdout, mock_stderr)
        sender = mock(:sender)
        sender.stub_chain(:mq_suite, :ensures).with(:connection).and_yield
        subject.stub(:sender).and_return(sender)
        sender.stub(:wait_for_connection).and_yield
      end

      it "実行に成功した場合はPIDが出力される" do
        subject.should_receive(:spawn_process).and_return(pid)
        mock_pid_file = mock(:pid_file)
        File.should_receive(:open).with(@pid_path, "a").and_yield(mock_pid_file)
        mock_pid_file.should_receive(:puts).with(pid)
        subject.should_receive(:start_wait_process).with(pid)
        EM.run do
          EM.add_timer(0.1) { EM.stop }
          subject.process
        end
      end

      it "ファイルが存在せずspawnに失敗した場合、エラーを出力する" do
        subject.should_receive(:spawn_process).and_raise(Errno::ENOENT.new(@echo_foo))
        mock_pid_file = mock(:pid_file)
        File.should_receive(:open).with(@pid_path, "a").and_yield(mock_pid_file)
        mock_pid_file.should_receive(:puts).with("[Errno::ENOENT] No such file or directory - #{@echo_foo}")
        timeout(0.5) do
          EM.run do
            # EM.add_timer(0.1) { EM.stop } # 起動に失敗したらEMは自動でstopされる
            subject.process
          end
        end
      end
    end

  end

  describe "#spawn_process" do
    let(:pid) { mock(Numeric.new) }
    let(:thr) { mock(Thread.start do Thread.stop end) }
    let(:stat) { mock($?) }
    before do
      o = mock(STDOUT)
      e = mock(STDERR)
      o.stub(:path).and_return(String.new)
      e.stub(:path).and_return(String.new)
      subject.instance_eval do
        @stdout = o
        @stderr = e
      end
    end

    it "spawnする" do
      echo_foo = File.expand_path "../scripts/echo_foo.sh", __FILE__
      Process.should_receive(:spawn).with(echo_foo, an_instance_of(Hash)).and_return(pid)
      subject.spawn_process.should == pid
    end

    it "No such file or directoryで失敗する" do
      echo_foo = File.expand_path "../scripts/echo_foo.sh", __FILE__
      Process.should_receive(:spawn).with(echo_foo, an_instance_of(Hash)).
        and_raise(Errno::ENOENT.new(echo_foo))
      expect {
        subject.spawn_process
      }.to raise_error(Errno::ENOENT)
    end
  end

  describe "#start_wait_process" do
    let(:pid) { mock(Numeric.new) }
    let(:stat) { mock($?) }
    before do
      bigzero = (1 << 1024).coerce(0).first
      stat.stub(:exitstatus).and_return(bigzero)
      pid.stub(:to_int).and_return(bigzero)
      Process.stub(:waitpid2).with(pid) do
        sleep 3
        [pid, stat]
      end
      subject.stub(:fire_finished) do EM.stop end
      subject.stub(:fire_heartbeat).with(pid).and_yield
    end

    it "pidを待つ" do
      EM.run do
        subject.should_receive(:fire_finished) do EM.stop end
        subject.start_wait_process(pid)
      end
    end

    it "heartbeatをfireしつづける" do
      EM.run do
        subject.should_receive(:fire_heartbeat).at_least(2).times.and_yield
        subject.start_wait_process(pid)
      end
    end

    it "https://www.pivotaltracker.com/story/show/21515847" do
      EM.run do
        subject.instance_eval { @config["heartbeat"]["job"]["interval"] = 0 }
        subject.unstub(:fire_heartbeat)
        subject.should_receive(:fire_heartbeat).at_least(1).times.and_yield
        subject.start_wait_process(pid)
      end
    end

    context "プロセスは正常に動き続けているがfireに失敗した場合" do
      it "その回のfireはあきらめる。例外などで死なない" do
        EM.run do
          subject.unstub(:fire_heartbeat)
          s = mock(Tengine::Event::Sender.new)
          subject.stub(:sender).and_return(s)
          def s.fire e, h, &b
            h[:retry_count].should_not == nil
            h[:retry_count].should == 0
            b.yield if b
          end
          expect {
            subject.start_wait_process(pid)
          }.to_not raise_exception(Tengine::Event::Sender::RetryError)
        end
      end
    end

    context "finishしたときのtimerの挙動" do
      def live_timers_count
        # これはひどい...
        ObjectSpace.each_object(EM::PeriodicTimer).reject do |i|
          i.instance_eval do
            @cancelled
          end
        end
      end
      it "https://www.pivotaltracker.com/story/show/21466285" do
        n = live_timers_count
        EM.run do
          subject.start_wait_process(pid)
        end
        live_timers_count.should == n
      end
    end
  end

  describe "#fire_finished" do
    let(:pid) { mock(Numeric.new) }
    let(:stat) { mock($?) }
    before do
      pid.stub(:to_int).and_return(-0.0/1.0)
      conn  = mock(:connection)
      ch    = Object.new

      AMQP.stub(:connect).with(an_instance_of(Hash)).and_return(conn)
      AMQP::Channel.stub(:new).with(conn, :prefetch => 1, :auto_recovery => true).and_return(ch)
      AMQP::Exchange.stub(:new).with(ch, "direct", "exchange1",
        :passive=>false, :durable=>true, :auto_delete=>false, :internal=>false, :nowait=>true)
      conn.stub(:on_tcp_connection_loss)
      conn.stub(:after_recovery)
      conn.stub(:on_closed)
      sender = mock(:sender)
      subject.stub(:sender).and_return(sender)
      sender.stub(:wait_for_connection).and_yield

      o = mock(STDOUT)
      e = mock(STDERR)
      o.stub(:path).and_return(String.new)
      e.stub(:path).and_return(String.new)
      subject.instance_eval do
        @stdout = o
        @stderr = e
      end
    end

    it "finished.process.job.tengineをfire" do
      EM.run do
        FileUtils.stub(:cp).with(an_instance_of(String), an_instance_of(String))
        stat.stub(:exitstatus).and_return(0)
        s = mock(Tengine::Event::Sender.new)
        subject.stub(:sender).and_return s
        s.stub(:stop)
        s.should_receive(:fire) do |k, v|
          k.should == "finished.process.job.tengine"
          v[:level_key].should == :info
          v[:properties]["pid"].should == pid
          v[:properties]["exit_status"].should == stat.exitstatus
        end
        subject.fire_finished(pid, stat)
        EM.add_timer(0.1) { EM.stop }
      end
    end

    it "プロセスが失敗していた場合" do
      EM.run do
        FileUtils.stub(:cp).with(an_instance_of(String), an_instance_of(String))
        stat.stub(:exitstatus).and_return(256)
        s = mock(Tengine::Event::Sender.new)
        subject.stub(:sender).and_return s
        s.stub(:stop)
        s.should_receive(:fire) do |k, v|
          k.should == "finished.process.job.tengine"
          v[:level_key].should == :error
          v[:properties][:message].should =~ /^Job process failed./
        end
        subject.fire_finished(pid, stat)
        EM.add_timer(0.1) { EM.stop }
      end
    end

    context "プロセスは正常に終了したがfireに失敗した場合" do
      it "fireできるようになるまでリトライを続ける" do
        EM.run do
          stat.stub(:exitstatus).and_return(0)
          s = mock(Tengine::Event::Sender.new)
          n = 0
          subject.stub(:sender).and_return(s)
          s.stub(:stop)
          s.stub(:fire).with("finished.process.job.tengine", an_instance_of(Hash)) do |e, h|
            if h[:retry_count]
                h[:retry_count].should > 0
            end
          end
          expect {
            subject.fire_finished(pid, stat)
          }.to_not raise_exception(Tengine::Event::Sender::RetryError)
          EM.add_timer(0.1) { EM.stop }
        end
      end
    end
  end

  describe "#sender" do
    before do
      conn = mock(:connection)
      conn.stub(:on_tcp_connection_loss)
      conn.stub(:after_recovery)
      conn.stub(:on_closed)
      AMQP.stub(:connect).with(an_instance_of(Hash)).and_return(conn)
    end
    subject { TengineJobAgent::Watchdog.new(@logger, %w"", @config).sender }
    it { should be_kind_of(Tengine::Event::Sender) }
  end
end
