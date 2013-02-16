# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

require 'net/ssh'


# 背景
# 以下の２つの条件が満たされ場合
#  * ２つのtenginedプロセスが動いている
#  * 並列で実行されるジョブを持つジョブネットが実行される(例えばrjn0002)
#
# 問題の詳細
# プロセス1がstart.job.job.tengineイベントによって起動したj11のプロセスのPIDを得る前に、
# プロセス2がstart.job.job.tengineイベントによってj12を起動することで、それらのルートジョブネットの
# versionが更新されてしまい、j11のPIDを得てルートジョブネットを更新する際にversionが
# 異なってしまっているため、update_with_lockメソッドによって実行に失敗したものと見なされて、
# 再度update_with_lockのブロックが実行されて、j11のプロセスが実行されてしまう。
#
# 本来どうあるべきか？
# update_with_lock内ではSSHなどの繰り返し実行することを想定していない処理や、
# イベントの送信を行ってはいけないので、それらの重複が起こらない仕組みになっているべき。
#
describe "<BUG>tengindのプロセスを二つ起動した際に並列ジョブがある際にジョブが２度実行される" do
  include Tengine::RSpec::Extension
  include NetSshMock

  driver_path = File.expand_path("../../../../../lib/tengine/job/runtime/drivers/job_control_driver.rb", File.dirname(__FILE__))

  # in [rjn0002]
  #              |--e2-->(j11)--e4-->|
  # (S1)--e1-->[F1]                [J1]--e6-->(E1)
  #              |--e3-->(j12)--e5-->|
  context "rjn0002" do
    before do
      Tengine::Resource::Server.delete_all
      Tengine::Job::Runtime::Execution.delete_all
      Tengine::Job::Runtime::Vertex.delete_all
      TestCredentialFixture.test_credential1
      TestServerFixture.test_server1
      TestServerFixture.test_server2
      builder = Rjn0002SimpleParallelJobnetBuilder.new
      @root = builder.create_actual
      j12 = @root.element("j12")
      j12.server_name = "test_server2"
      @root.save!

      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @base_props = {
        :execution_id => @execution.id.to_s,
        :root_jobnet_id => @root.id.to_s,
        :root_jobnet_name_path => @root.name_path,
        :target_jobnet_id => @root.id.to_s,
        :target_jobnet_name_path => @root.name_path,
      }

      # 2つのプロセスの代わりに、2つのカーネルを別のFiberで動かす
      @bootstrap1 = Tengine::Core::Bootstrap.new(:tengined => { :load_path => driver_path })
      @bootstrap1.kernel.tap{|k| k.bind; k.evaluate}
      @tengine1 = Tengine::RSpec::ContextWrapper.new(@bootstrap1.kernel)
      #
      @bootstrap2 = Tengine::Core::Bootstrap.new(:tengined => { :load_path => driver_path })
      @bootstrap2.kernel.tap{|k| k.bind; k.evaluate}
      @tengine2 = Tengine::RSpec::ContextWrapper.new(@bootstrap2.kernel)
    end

    # tengine1が起動したプロセスのPIDを得る前にtengine2がプロセスを起動することはできません。
    #
    # job_control_driverでのstart.job.job.tengineの処理の概略以下の通りです
    #
    # start.job.job.tengine
    # 1. be starting
    # 2. root_jobnet.update_with_lock
    # 3. execute job with SSH
    # 4. be running
    # 5. root_jobnet.update_with_lock
    #
    # パターン1 (ほぼ同時に1に突入する)
    # ||f1      ||f2      ||DB |
    # ||ver|step||ver|step||ver|
    # ---------------------------------------------------------
    # || 0 |  1 || - |  - ||  0| f1 starting
    # || 0 |  1 || 0 |  1 ||  0| f2 starting 1st
    # || 1 |  2 || 0 |  1 ||  1| f1 update_with_lock success
    # || 1 |  2 || 0 |  2 ||  1| f2 update_with_lock fail & retry
    # || 1 |  2 || 1 |  1 ||  1| f2 starting 2nd
    # || 1 |  2 || 2 |  2 ||  2| f2 update_with_lock success
    # || 2 |  3 || 2 |  2 ||  2| f1 refrsh & SSH starting
    # || 2 |  3 || 2 |  3 ||  2| f2 refrsh & SSH starting
    # || 2 |  4 || 2 |  3 ||  2| f1 running
    # || 3 |  5 || 2 |  3 ||  3| f1 update_with_lock success
    # || 3 |  5 || 2 |  4 ||  3| f2 running 1st
    # || 3 |  5 || 2 |  5 ||  3| f2 update_with_lock fail & retry
    # || 3 |  5 || 3 |  4 ||  3| f2 running 2nd
    # || 3 |  5 || 4 |  5 ||  4| f2 update_with_lock success

    before do
      @ctx[:e1].phase_key = :transmitted
      @ctx[:e2].phase_key = :transmitting
      @ctx[:e3].phase_key = :transmitting
      @ctx[:j11].update_phase! :ready
      @ctx[:j12].update_phase! :ready
      @root.phase_key = :starting
      @root.version = 0
      @root.save!

      @pid = Process.pid.to_s

      @f1 = Fiber.new do
        ssh1 = mock(:ssh1)
        Net::SSH.should_receive(:start).with("localhost",
          an_instance_of(Tengine::Resource::Credential),
          an_instance_of(Hash)).once.and_yield(ssh1)
        channel1 = mock_channel_fof_script_executable(ssh1, :channel1)
        channel1.stub(:exec).with(any_args).and_yield(channel1, true)
        channel1.should_receive(:on_close) do
          Tengine.logger.debug( ("!" * 100) << "\non_close: Fiber.yield #{Process.pid} #{__FILE__}##{__LINE__}")
          Fiber.yield
        end # on_dataが呼び出される前に止める
        channel1.should_receive(:on_data).and_yield(channel1, @pid)
        channel1.stub(:on_extended_data)
        @tengine1.receive("start.job.job.tengine", :properties => {
            :target_job_id => @ctx.vertex(:j11).id.to_s,
            :target_job_name_path => @ctx.vertex(:j11).name_path,
          }.update(@base_props))
        :end
      end

      @f2 = Fiber.new do
        ssh2 = mock(:ssh2)
        Net::SSH.should_receive(:start).with("192.168.1.2",
          an_instance_of(Tengine::Resource::Credential),
          an_instance_of(Hash)).once.and_yield(ssh2)
        channel2 = mock_channel_fof_script_executable(ssh2, :channel2)
        channel2.stub(:exec).with(any_args).and_yield(channel2, true)
        channel2.should_receive(:on_close) do
          Tengine.logger.debug( ("!" * 100) << "\non_close: Fiber.yield #{Process.pid} #{__FILE__}##{__LINE__}")
          Fiber.yield
        end # on_dataが呼び出される前に止める
        channel2.should_receive(:on_data).and_yield(channel2, @pid)
        channel2.stub(:on_extended_data)
        @tengine2.receive("start.job.job.tengine", :properties => {
            :target_job_id => @ctx.vertex(:j12).id.to_s,
            :target_job_name_path => @ctx.vertex(:j12).name_path,
          }.update(@base_props))
        :end
      end

      @j11 = @root.element("j11")
      @j12 = @root.element("j12")

      @root.reload
      @root.version.should == 0
      Tengine::Job.test_harness_clear
    end

    it "パターン1" do
      # f1-1.
      Tengine.logger.info("1" * 100)
      Tengine::Job.should_receive(:test_harness).with(1, "before yield in update_with_lock").once
      Tengine::Job.should_receive(:test_harness).with(2, "after yield in update_with_lock").once{ Fiber.yield}
      @f1.resume.should_not == :end
      @root.reload
      @root.version.should == 0
      @root.element("j11").phase_key.should == :ready
      @root.element("j12").phase_key.should == :ready

      # f2-1.
      Tengine.logger.info("2" * 100)
      Tengine::Job.should_receive(:test_harness).with(3, "before yield in update_with_lock").once
      Tengine::Job.should_receive(:test_harness).with(4, "after yield in update_with_lock").once{ Fiber.yield}
      @f2.resume.should_not == :end
      @root.reload
      @root.version.should == 0
      @root.element("j11").phase_key.should == :ready
      @root.element("j12").phase_key.should == :ready

      # f1-2.
      Tengine.logger.info("3" * 100)
      Tengine::Job.should_receive(:test_harness).with(5, "after update_with_lock").once{ Fiber.yield}
      @f1.resume.should_not == :end
      @root.reload
      @root.version.should == 1
      @root.element("j11").phase_key.should == :starting
      @root.element("j12").phase_key.should == :ready

      # f2-1.
      Tengine.logger.info("4" * 100)
      Tengine::Job.should_receive(:test_harness).with(6, "before yield in update_with_lock").once.once
      Tengine::Job.should_receive(:test_harness).with(7, "after yield in update_with_lock").once.once{ Fiber.yield}
      @f2.resume.should_not == :end
      @root.reload
      @root.version.should == 1
      @root.element("j11").phase_key.should == :starting
      @root.element("j12").phase_key.should == :ready

      # f2-2.
      Tengine.logger.info("5" * 100)
      Tengine::Job.should_receive(:test_harness).with(8, "after update_with_lock").once{ Fiber.yield}
      @f2.resume.should_not == :end
      @root.reload
      @root.version.should == 2
      @root.element("j11").phase_key.should == :starting
      @root.element("j12").phase_key.should == :starting

      # f1-3.
      Tengine.logger.info("6" * 100)
      @f1.resume.should_not == :end
      @root.reload
      @root.version.should == 2
      @root.element("j11").phase_key.should == :starting
      @root.element("j12").phase_key.should == :starting

      # f2-3.
      Tengine.logger.info("7" * 100)
      @f2.resume.should_not == :end
      @root.reload
      @root.version.should == 2
      @root.element("j11").phase_key.should == :starting
      @root.element("j12").phase_key.should == :starting

      # f1-4.
      Tengine.logger.info("8" * 100)
      Tengine::Job.should_receive(:test_harness).with(9, "before yield in update_with_lock").once
      Tengine::Job.should_receive(:test_harness).with(10, "after yield in update_with_lock").once{ Fiber.yield }
      @f1.resume.should_not == :end
      @root.reload
      @root.version.should == 2
      @root.element("j11").phase_key.should == :starting
      @root.element("j12").phase_key.should == :starting

      # f1-5.
      Tengine.logger.info("9" * 100)
      Tengine::Job.should_receive(:test_harness).with(11, "after update_with_lock").once
      @f1.resume.should == :end
      @root.reload
      @root.version.should == 3
      @root.element("j11").tap do |j|
        j.phase_key.should == :running
        j.executing_pid.should_not be_nil
      end
      @root.element("j12").phase_key.should == :starting

      # f2-4. 1st
      Tengine.logger.info("a" * 100)
      Tengine::Job.should_receive(:test_harness).with(12, "before yield in update_with_lock").once
      Tengine::Job.should_receive(:test_harness).with(13, "after yield in update_with_lock").once{ Fiber.yield }
      @f2.resume.should_not == :end
      @root.reload
      @root.version.should == 3
      @root.element("j11").tap do |j|
        j.phase_key.should == :running
        j.executing_pid.should_not be_nil
      end
      @root.element("j12").phase_key.should == :starting

      # f2-5.
      Tengine.logger.info("b" * 100)
      Tengine::Job.should_receive(:test_harness).with(14, "before yield in update_with_lock").once{ Fiber.yield }
      @f2.resume.should_not == :end
      @root.reload
      @root.version.should == 3
      @root.element("j11").tap do |j|
        j.phase_key.should == :running
        j.executing_pid.should_not be_nil
      end
      @root.element("j12").phase_key.should == :starting

      # f2-4. 2nd
      Tengine.logger.info("c" * 100)
      Tengine::Job.should_receive(:test_harness).with(15, "after yield in update_with_lock").once{ Fiber.yield }
      @f2.resume.should_not == :end
      @root.reload
      @root.version.should == 3
      @root.element("j11").tap do |j|
        j.phase_key.should == :running
        j.executing_pid.should_not be_nil
      end
      @root.element("j12").phase_key.should == :starting

      # f2-5.
      Tengine.logger.info("d" * 100)
      Tengine::Job.should_receive(:test_harness).with(16, "after update_with_lock").once
      @f2.resume.should == :end
      @root.reload
      @root.version.should == 4
      @root.element("j11").tap do |j|
        j.phase_key.should == :running
        j.executing_pid.should_not be_nil
      end
      @root.element("j12").tap do |j|
        j.executing_pid.should_not be_nil
        j.phase_key.should == :running
      end
    end

  end
end
