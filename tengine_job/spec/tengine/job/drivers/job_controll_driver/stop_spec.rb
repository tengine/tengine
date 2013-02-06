# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

require 'net/ssh'

describe "<BUG>(tengined複数起動)強制停止すると、ステータスが「強制停止済」ではなく「エラー終了」になる" do
  include Tengine::RSpec::Extension
  include NetSshMock

  driver_path = File.expand_path("../../../../../lib/tengine/job/drivers/job_control_driver.rb", File.dirname(__FILE__))

  #
  # in [jn0004]
  #                         |--e3-->(j2)--e5-->|
  # (S1)--e1-->(j1)--e2-->[F1]                [J1]--e7-->(j4)--e8-->(E1)
  #                         |--e4-->(j3)--e6-->|
  #
  # in [jn0004/finally]
  # (S2) --e9-->(jn0004_f)-e10-->(E2)
  #
  # 現象:
  # j1を強制停止した際に、プロセスが２つ動いている場合、その片方のプロセスAが
  # stop.job.job.tengineイベントを受け取りSSHでtengine_job_agent_killを実行します。
  # その実行の戻り値を得るまでの間に、もう片方のプロセスBが、プロセスが終了して発火される
  # finished.process.job.tengineイベントを処理すると、stop_reasonがuser_stopでなくなってしまっていました。
  #
  context "jn0004" do
    before do
      Tengine::Resource::Server.delete_all
      Tengine::Job::Execution.delete_all
      Tengine::Job::Vertex.delete_all
      TestCredentialFixture.test_credential1
      TestServerFixture.test_server1
      TestServerFixture.test_server2
      builder = Rjn0004ParallelJobnetWithFinally.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Execution.create!({
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

    before do
      @pid = "123"
      @ctx[:e1].phase_key = :transmitted
      @ctx[:j1].tap do |j|
        j.phase_key = :running
        j.executing_pid = @pid
      end
      @root.phase_key = :running
      @root.version = 4
      @root.save!

      @f1 = Fiber.new do
        @tengine1.should_not_fire
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
        channel1.stub(:on_data)
        channel1.stub(:on_extended_data)
        @tengine1.receive("stop.job.job.tengine", :properties => {
            :stop_reason => "user_stop",
            :target_job_id => @ctx.vertex(:j1).id.to_s,
            :target_job_name_path => @ctx.vertex(:j1).name_path,
          }.update(@base_props))
        :end
      end

      @f2 = Fiber.new do
        @tengine2.should_fire(:"error.job.job.tengine", {
            :source_name => @ctx[:j1].name_as_resource,
            :properties=>{
              :target_job_id => @ctx.vertex(:j1).id.to_s,
              :target_job_name_path => @ctx.vertex(:j1).name_path,
              :exit_status=>nil,
            }.update(@base_props)
          })
        @tengine2.receive("finished.process.job.tengine", :properties => {
            :pid=>17485,
            :exit_status=>nil,
            :target_job_id => @ctx.vertex(:j1).id.to_s,
            :target_job_name_path => @ctx.vertex(:j1).name_path,
          }.update(@base_props))
        :end
      end

      @j1 = @root.element("j1")

      @root.reload
      @root.version.should == 4
      Tengine::Job.test_harness_clear
    end

    it "tengine_job_agent_killの戻り値の前にfinished.process.job.tengineが来ても強制終了となるべき" do
      # f1-1.
      Tengine.logger.info("1" * 100)
      # Tengine::Job.should_receive(:test_harness).with(1, "before yield in update_with_lock").once
      # Tengine::Job.should_receive(:test_harness).with(2, "after yield in update_with_lock").once{ Fiber.yield}
      @f1.resume.should_not == :end
      @root.reload
      @root.version.should == 5
      @root.element("j1").tap do |j|
        j.phase_key.should == :dying
        j.executing_pid.should == @pid
        j.stop_reason.should == "user_stop"
      end

      # f2
      Tengine.logger.info("2" * 100)
      # Tengine::Job.should_receive(:test_harness).with(3, "before yield in update_with_lock").once
      # Tengine::Job.should_receive(:test_harness).with(4, "after yield in update_with_lock").once{ Fiber.yield}
      @f2.resume.should == :end
      @root.reload
      @root.version.should == 6
      @root.element("j1").tap do |j|
        j.phase_key.should == :error
        j.executing_pid.should == @pid
        j.stop_reason.should == "user_stop"
      end

      # f1-2.
      Tengine.logger.info("3" * 100)
      # Tengine::Job.should_receive(:test_harness).with(5, "after update_with_lock").once{ Fiber.yield}
      @f1.resume.should == :end
      @root.reload
      @root.version.should == 6
      @root.element("j1").tap do |j|
        j.phase_key.should == :error
        j.executing_pid.should == @pid
        j.stop_reason.should == "user_stop"
      end
    end

  end
end
