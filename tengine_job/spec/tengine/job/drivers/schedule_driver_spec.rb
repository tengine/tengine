# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

describe 'schedule_driver' do
  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../../../../lib/tengine/job/runtime/drivers/schedule_driver.rb", File.dirname(__FILE__))
  driver :schedule_driver

  context "rjn0001" do
    before do
      Tengine::Core::Schedule.delete_all
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0001SimpleJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
    end

    context "start" do
      before do
        # start.execution.job.tengineをreceiveすると
        # job_execution_driverも受け取ってしまって、それが
        # start.jobnet.job.tengineをfireしようとして、
        # MQに接続しようとするので、適当にstubする必要がある
        kern = ObjectSpace.each_object(Tengine::Core::Kernel) {|i| break i }
        send = mock(:sender)
        kern.stub(:sender).and_return(send)
        send.stub(:fire)
      end

      it "タイムアウトが設定されていない場合はなにもしない" do
        @execution.phase_key = :initialized
        @execution.unset :actual_base_timeout_alert
        @execution.unset :actual_base_timeout_termination
        @execution.save!
        @root.phase_key = :initialized
        @root.save!
        EM.run_block do
          tengine.receive("start.execution.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :target_jobnet_id => @root.id.to_s,
          })
        end
        Tengine::Core::Schedule.where(:status => Tengine::Core::Schedule::SCHEDULED).should be_empty
      end

      it "タイムアウトが0で設定されていた場合はなにもしない" do
        @execution.phase_key = :initialized
        @execution.actual_base_timeout_alert = 0
        @execution.actual_base_timeout_termination = 0
        @execution.save!
        @root.phase_key = :initialized
        @root.save!
        EM.run_block do
          tengine.receive("start.execution.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :target_jobnet_id => @root.id.to_s,
          })
        end
        Tengine::Core::Schedule.where(:status => Tengine::Core::Schedule::SCHEDULED).should be_empty
      end

      it "タイムアウトが設定されていればスケジュールストアに保存" do
        @execution.phase_key = :initialized
        @execution.actual_base_timeout_alert = 32768
        @execution.actual_base_timeout_termination = 65536
        @execution.save!
        @root.phase_key = :initialized
        @root.save!
        EM.run_block do
          tengine.receive("start.execution.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :target_jobnet_id => @root.id.to_s,
          })
        end
        Tengine::Core::Schedule.where({:status => Tengine::Core::Schedule::SCHEDULED}).count.should == 2
        s1 = Tengine::Core::Schedule.where({:event_type_name => "alert.execution.job.tengine"}).first
        s2 = Tengine::Core::Schedule.where({:event_type_name => "stop.execution.job.tengine"}).first
        [s1, s2].each do |i|
          i.source_name.should == @execution.name_as_resource
          i.scheduled_at.should >= Time.now
        end
        s1.properties.should == {
          'execution_id' => @execution.id.to_s,
          'root_jobnet_id' => @root.id.to_s,
          'target_jobnet_id' => @root.id.to_s,
        }
        s2.properties.should == {
          'execution_id' => @execution.id.to_s,
          'root_jobnet_id' => @root.id.to_s,
          'target_jobnet_id' => @root.id.to_s,
          'stop_reason'=>'timeout'
        }
      end

      it "tenginedクラッシュからの復帰" do
        Tengine::Core::Schedule.delete_all
        @execution.phase_key = :initialized
        @execution.actual_base_timeout_alert = 32768
        @execution.actual_base_timeout_termination = 65536
        @execution.save!
        @root.phase_key = :initialized
        @root.save!
        EM.run_block do
          tengine.receive("start.execution.job.tengine.failed.tengined", :properties => {
            :original_event => {
              :event_type_name => "start.execution.job.tengine",
              :properties => {
                :execution_id => @execution.id.to_s,
                :root_jobnet_id => @root.id.to_s,
                :target_jobnet_id => @root.id.to_s,
              }}})
        end
        Tengine::Core::Schedule.where({:status => Tengine::Core::Schedule::SCHEDULED}).count.should == 2
        s1 = Tengine::Core::Schedule.where({:event_type_name => "alert.execution.job.tengine"}).first
        s2 = Tengine::Core::Schedule.where({:event_type_name => "stop.execution.job.tengine"}).first
        [s1, s2].each do |i|
          i.source_name.should == @execution.name_as_resource
          i.scheduled_at.should >= Time.now
        end
        s1.properties.should == {
          'execution_id' => @execution.id.to_s,
          'root_jobnet_id' => @root.id.to_s,
          'target_jobnet_id' => @root.id.to_s,
        }
        s2.properties.should == {
          'execution_id' => @execution.id.to_s,
          'root_jobnet_id' => @root.id.to_s,
          'target_jobnet_id' => @root.id.to_s,
          'stop_reason'=>'timeout'
        }
        
      end
    end

    shared_examples "terminated" do
      it "タイムアウトが設定されていない場合はなにもしない #1" do
        Tengine::Core::Schedule.delete_all
        EM.run_block do
          tengine.receive(event, :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :target_jobnet_id => @root.id.to_s,
          })
        end
        Tengine::Core::Schedule.should be_empty
      end

      it "タイムアウトが設定されていない場合はなにもしない #2" do
        s0 = Tengine::Core::Schedule.new
        s0.status = Tengine::Core::Schedule::SCHEDULED
        s0.scheduled_at = Time.at 0
        s0.save
        s1 = Tengine::Core::Schedule.new
        s1.status = Tengine::Core::Schedule::INVALID
        s1.scheduled_at = Time.at 0
        s1.source_name = @execution.name_as_resource
        s1.save
        EM.run_block do
          tengine.receive(event, :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :target_jobnet_id => @root.id.to_s,
          })
        end
        s0.reload
        s0.status.should == Tengine::Core::Schedule::SCHEDULED
        s1.reload
        s1.status.should == Tengine::Core::Schedule::INVALID
      end

      it "タイムアウトが設定されているが既に終了してしまっている場合も何もしない" do
        s0 = Tengine::Core::Schedule.new
        s0.status = Tengine::Core::Schedule::FIRED
        s0.scheduled_at = Time.at 0
        s0.source_name = @execution.name_as_resource
        s0.save
        EM.run_block do
          tengine.receive(event, :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :target_jobnet_id => @root.id.to_s,
          })
        end
        s0.reload
        s0.status.should == Tengine::Core::Schedule::FIRED
      end

      it "タイムアウトが設定されていてかつまだ終了していない場合はinvalidateする #1" do
        s0 = Tengine::Core::Schedule.new
        s0.status = Tengine::Core::Schedule::SCHEDULED
        s0.scheduled_at = Time.at 0
        s0.source_name = @execution.name_as_resource
        s0.save
        EM.run_block do
          tengine.receive(event, :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :target_jobnet_id => @root.id.to_s,
          })
        end
        s0.reload
        s0.status.should == Tengine::Core::Schedule::INVALID
      end

      it "タイムアウトが設定されていてかつまだ終了していない場合はinvalidateする #2" do
        s0 = Tengine::Core::Schedule.new
        s0.status = Tengine::Core::Schedule::SCHEDULED
        s0.scheduled_at = Time.now + 32768
        s0.source_name = @execution.name_as_resource
        s0.save
        EM.run_block do
          tengine.receive(event, :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :target_jobnet_id => @root.id.to_s,
          })
        end
        s0.reload
        s0.status.should == Tengine::Core::Schedule::INVALID
      end
    end

    context "success" do
      let(:event) { "success.execution.job.tengine" }
      it_should_behave_like "terminated"
    end

    context "error" do
      let(:event) { "error.execution.job.tengine" }
      it_should_behave_like "terminated"
    end
  end
end
