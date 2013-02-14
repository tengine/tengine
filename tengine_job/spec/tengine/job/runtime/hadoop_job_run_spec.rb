# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'hadoop_job_run' do

  context "rjn1004" do
    before(:all) do
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn1004HadoopJobInJobnetFixture.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
    end

    Tengine::Job::Runtime::Jobnet.phase_keys.each do |phase_key|
      context "hadoop_job_run1のphase_keyを#{phase_key}に設定する" do
        before(:all) do
          @ctx[:hadoop_job_run1].tap do |j|
            j.phase_key = phase_key
          end
          @root.save_descendants!
        end

        %w[
           /rjn1004/hadoop_job_run1/hadoop_job1
           /rjn1004/hadoop_job_run1/hadoop_job1/Map
           /rjn1004/hadoop_job_run1/hadoop_job1/Reduce
           /rjn1004/hadoop_job_run1/hadoop_job2
           /rjn1004/hadoop_job_run1/hadoop_job2/Map
           /rjn1004/hadoop_job_run1/hadoop_job2/Reduce
        ].each do |name_path|
          it "その子どものhadoop_job, Map, Reduceのphase_keyも#{phase_key}になる" do
            @root.vertex_by_name_path(name_path).phase_key.should == phase_key
          end
        end
      end

      context "https://www.pivotaltracker.com/story/show/23329935" do
        before(:all) do
          @ctx[:hadoop_job_run1].tap do |j|
            j.stopped_at = Time.at(0)
            j.stop_reason = "test test"
          end
          @root.save_descendants!
        end

        %w[
           /rjn1004/hadoop_job_run1/hadoop_job1
           /rjn1004/hadoop_job_run1/hadoop_job1/Map
           /rjn1004/hadoop_job_run1/hadoop_job1/Reduce
           /rjn1004/hadoop_job_run1/hadoop_job2
           /rjn1004/hadoop_job_run1/hadoop_job2/Map
           /rjn1004/hadoop_job_run1/hadoop_job2/Reduce
        ].each do |name_path|
          it "その子どもの#{name_path}のstop_reasonもtest testになる" do
            @root.vertex_by_name_path(name_path).stop_reason.should == "test test"
          end
          it "その子どもの#{name_path}のstopped_atも0になる" do
            @root.vertex_by_name_path(name_path).stopped_at.to_f.should == 0.0
          end
        end
      end
    end

  end

end
