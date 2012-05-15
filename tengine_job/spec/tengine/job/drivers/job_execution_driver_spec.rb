# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

describe 'job_execution_driver' do
  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../../../../lib/tengine/job/drivers/job_execution_driver.rb", File.dirname(__FILE__))
  driver :job_execution_driver

  # in [rjn0001]
  # (S1) --e1-->(j11)--e2-->(j12)--e3-->(E1)
  context "rjn0001" do
    before do
      Tengine::Job::Vertex.delete_all
      builder = Rjn0001SimpleJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Execution.create!({
          :root_jobnet_id => @root.id,
        })
    end

    it "ジョブの起動イベントを受け取ったら" do
      @execution.phase_key = :initialized
      @execution.save!
      @root.phase_key = :initialized
      @root.save!
      tengine.should_fire(:"start.jobnet.job.tengine",
        :source_name => @root.name_as_resource,
        :properties => {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @root.id.to_s,
          :root_jobnet_name_path => @root.name_path,
          :target_jobnet_id => @root.id.to_s,
          :target_jobnet_name_path => @root.name_path,
        })
      tengine.receive("start.execution.job.tengine", :properties => {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @root.id.to_s,
          :root_jobnet_name_path => @root.name_path,
          :target_jobnet_id => @root.id.to_s,
          :target_jobnet_name_path => @root.name_path,
        })
      @execution.reload
      @execution.phase_key.should == :starting
      @root.reload
      @root.phase_key.should == :ready
    end

    it "start.execution.job.tengine.failed.tengined, double save" do
      @execution.phase_key = :initialized
      @execution.save!
      @root.phase_key = :initialized
      @root.save!
      tengine.receive("start.execution.job.tengine.failed.tengined", :properties => {
          :original_event => {
            :event_type_name => "start.execution.job.tengine",
            :properties => {
              :execution_id => @execution.id.to_s,
              :root_jobnet_id => @root.id.to_s,
              :root_jobnet_name_path => @root.name_path,
              :target_jobnet_id => @root.id.to_s,
              :target_jobnet_name_path => @root.name_path,
            }}})
      @execution.reload
      @execution.phase_key.should == :stuck
    end

    it "start.execution.job.tengine.failed.tengined, broken event" do
      @execution.phase_key = :initialized
      @execution.save!
      @root.phase_key = :initialized
      @root.save!
      tengine.receive("start.execution.job.tengine.failed.tengined", :properties => {
          :original_event => {
            :event_type_name => "start.execution.job.tengine",
            :properties => {}}})
      @execution.reload
      @execution.phase_key.should_not == :stuck
    end

    %w[user_stop timeout].each do |stop_reason|
      context stop_reason do
        it "強制停止イベントを受け取ったら" do
          @execution.phase_key = :running
          @execution.save!
          @root.phase_key = :running
          @root.save!
          tengine.should_fire(:"stop.jobnet.job.tengine",
            :source_name => @root.name_as_resource,
            :properties => {
              :execution_id => @execution.id.to_s,
              :root_jobnet_id => @root.id.to_s,
              :root_jobnet_name_path => @root.name_path,
              :target_jobnet_id => @root.id.to_s,
              :target_jobnet_name_path => @root.name_path,
              :stop_reason => stop_reason
            })
          tengine.receive("stop.execution.job.tengine",
            :source_name => @execution.name_as_resource,
            :properties => {
              :execution_id => @execution.id.to_s,
              :root_jobnet_id => @root.id.to_s,
              :root_jobnet_name_path => @root.name_path,
              :target_jobnet_id => @root.id.to_s,
              :target_jobnet_name_path => @root.name_path,
              :stop_reason => stop_reason
            })
          @execution.reload
          @execution.phase_key.should == :dying
          @root.reload
          @root.phase_key.should == :running
        end
      end
    end
    # jobnet_control_driverでexecution起動後の処理を行っています

    it "stop.execution.job.tengine.failed.tengined" do
      @execution.phase_key = :running
      @execution.save!
      @root.phase_key = :running
      @root.save!
      tengine.receive("stop.execution.job.tengine.failed.tengined", :properties => {
          :original_event => {
            :event_type_name => "STOP.execution.job.tengine",
            :properties => {
              :execution_id => @execution.id.to_s,
              :root_jobnet_id => @root.id.to_s,
              :root_jobnet_name_path => @root.name_path,
              :target_jobnet_id => @root.id.to_s,
              :target_jobnet_name_path => @root.name_path,
            }}})
      @execution.reload
      @execution.phase_key.should == :stuck
    end
  end
end
