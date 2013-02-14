# -*- coding: utf-8 -*-
require 'spec_helper'

require 'net/ssh'

describe Tengine::Job::Runtime::Stoppable do
  include TestCredentialFixture
  include TestServerFixture
  include NetSshMock

  describe :stop do
    context "rjn0011" do
      before do
        builder = Rjn0011NestedForkJobnetBuilder.new
        @ctx = builder.context
        @root = builder.create_actual
        [:j1110, :j1121, :j1131, :j1140].each do |name|
          @ctx[name].tap do |j|
            j.server_name = builder.send(:test_server1).name
            j.credential_name = builder.send(:test_credential1).name
            j.killing_signals = ["INT", "HUP", "QUIT", "KILL"]
            j.killing_signal_interval = 30
            j.save!
          end
        end
        [:j1200, :j1310].each do |name|
          @ctx[name].tap do |j|
            j.server_name = builder.send(:test_server1).name
            j.credential_name = builder.send(:test_credential1).name
            j.killing_signals = Tengine::Job::Template::SshJob::Settings::DEFAULT_KILLING_SIGNALS.dup
            j.killing_signal_interval = Tengine::Job::Template::SshJob::Settings::DEFAULT_KILLING_SIGNAL_INTERVAL
            j.save!
          end
        end
        @execution = Tengine::Job::Runtime::Execution.create!({
            :root_jobnet_id => @root.id,
          })
        @mock_event = mock(:event,
          :occurred_at => Time.utc(2011,10,28,0,50))
        @mock_event.stub!(:[]).with(:execution_id).and_return(@execution.id.to_s)
        @signal = Tengine::Job::Runtime::Signal.new(@mock_event)
      end

      context "強制停止しても何も変更なし" do
        ([:dying, :success, :error, :stuck]).each do |phase_key|
          it "#{phase_key}の場合" do
            @ctx[:j1110].phase_key = phase_key
            expect{
              @ctx[:j1110].stop(@signal)
            }.to_not raise_error
            @ctx[:j1110].phase_key.should == phase_key
          end
        end
      end

      context ":readyならば:initializedに戻す" do
        # 特別ルール「starting直前stop」
        # initializedに戻されたジョブに対して、:readyになる際にtransmitで送信されたイベントを受け取って、
        # activateしようとすると状態は遷移しないが、後続のエッジを実行する。
        # (エッジを実行しようとした際、エッジがclosedならばそのジョブネットのEndに遷移する。)

        it "(ジョブネットに対するstopによって)後続のエッジをcloseしてある場合" do
          t = Time.at(Time.now.to_i)
          @mock_event.should_receive(:occurred_at).and_return(t)
          @mock_event.should_receive(:[]).with(:stop_reason).and_return("test stopping")
          [:e6, :e7, :e8, :e9].each{|name| @ctx[name].phase_key = :closing}
          @ctx[:j1110].tap do |j|
            j.phase_key = :ready
            j.executing_pid = nil
            j.save!
            @ctx[:j1100].should_receive(:fail).with(@signal)
            j.stop(@signal)
            j.phase_key.should == :initialized
            j.stop_reason.should == "test stopping"
            j.stopped_at.to_time.should == t
          end
          [:e6, :e7, :e8, :e9].each{|name| @ctx[name].phase_key.should == :closed}
        end

        it "(ジョブを単体で停止する)エッジはcloseしていない場合" do
          t = Time.at(Time.now.to_i)
          @mock_event.should_receive(:occurred_at).and_return(t)
          @mock_event.should_receive(:[]).with(:stop_reason).and_return("test stopping")
          @ctx[:j1110].tap do |j|
            j.phase_key = :ready
            j.executing_pid = nil
            @ctx[:j1120].should_receive(:transmit).with(@signal)
            j.stop(@signal)
            j.phase_key.should == :initialized
            j.stop_reason.should == "test stopping"
            j.stopped_at.to_time.should == t
          end
        end
      end

      context ":startingならば:runningになるのを待って、stopする" do

        it "(ジョブを単体で停止する)エッジはcloseしていない場合" do
          pending "TODO 要調査"

          t = Time.at(Time.now.to_i)
          @mock_event.should_receive(:occurred_at).and_return(t)
          @mock_event.should_receive(:[]).with(:stop_reason).and_return("test stopping")
          @ctx[:j1110].tap do |j|
            j.phase_key = :starting
            j.executing_pid = nil
            @root.save!
            @pid = "111"
            @root.reload

            mock_ssh = mock(:ssh)
            Net::SSH.should_receive(:start).
              with(test_server1.hostname_or_ipv4,
              an_instance_of(Tengine::Resource::Credential),
              an_instance_of(Hash)).and_yield(mock_ssh)
            mock_channel = mock_channel_fof_script_executable(mock_ssh)
            mock_channel.should_receive(:exec) do |*args|
              args.length.should == 1
              args.first.tap do |cmd|
                cmd.should =~ /tengine_job_agent_kill #{@pid} 30 INT,HUP,QUIT,KILL/
              end
            end

            idx = 0
            @root.vertex(j.id).stop(@signal) do
              idx += 1
              if idx >= 3 # 3回目のリトライ後にデータが更新され、4回目でループを抜けて強制停止が始まります
                root_dup = @root.class.find(@root.id)
                job = root_dup.vertex(j.id)
                job.executing_pid = @pid
                job.phase_key = :running
                root_dup.save!
              end
            end
            @root.save!
            job = @root.vertex(j.id)
            job.phase_key.should == :dying
            job.stop_reason.should == "test stopping"
            job.stopped_at.to_time.should == t
            @signal.callback.should_not be_nil
            @signal.callback.call
          end
        end
      end


      shared_examples_for "SSHでtengine_job_agent_killを実行する" do |name, interval, signals|
        it do
          @pid = "111"
          mock_ssh = mock(:ssh)
          Net::SSH.should_receive(:start).
            with(test_server1.hostname_or_ipv4,
            an_instance_of(Tengine::Resource::Credential),
            an_instance_of(Hash)).and_yield(mock_ssh)
          mock_channel = mock_channel_fof_script_executable(mock_ssh)
          mock_channel.should_receive(:exec) do |*args|
            args.length.should == 1
            args.first.tap do |cmd|
              cmd.should =~ /tengine_job_agent_kill #{@pid} #{interval} #{signals}/
            end
          end
          t = Time.at(Time.now.to_i)
          @mock_event.should_receive(:occurred_at).and_return(t)
          @mock_event.should_receive(:[]).with(:stop_reason).and_return("test stopping")
          @ctx[name].tap do |j|
            j.reload
            j.phase_key = :running
            j.executing_pid = @pid
            j.save!
            j.stop(@signal)
            j.phase_key.should == :dying
            j.stop_reason.should == "test stopping"
            j.stopped_at.to_time.should == t
            j.save!
          end
          @signal.callback.should_not be_nil
          @signal.callback.call
        end
      end

      default_interval = Tengine::Job::Template::SshJob::Settings::DEFAULT_KILLING_SIGNAL_INTERVAL
      [
        [:j1110, 30, "INT,HUP,QUIT,KILL"],
        [:j1121, 30, "INT,HUP,QUIT,KILL"],
        [:j1131, 30, "INT,HUP,QUIT,KILL"],
        [:j1140, 30, "INT,HUP,QUIT,KILL"],
        [:j1200, default_interval, "KILL"],
        [:j1310, default_interval, "KILL"],
      ].each do |args|
        it_should_behave_like "SSHでtengine_job_agent_killを実行する", *args
      end

    end
  end
end
