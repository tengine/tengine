# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'hadoop_job_run' do

  context "rjn1004" do
    before(:all) do
      Tengine::Job::Vertex.delete_all
      builder = Rjn1004HadoopJobInJobnetFixture.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Execution.create!({
          :root_jobnet_id => @root.id,
        })
    end

    Tengine::Job::Runtime::Jobnet.phase_keys.each do |phase_key|
      context "hadoop_job_run1のphase_keyを#{phase_key}に設定する" do
        before(:all) do
          @ctx[:hadoop_job_run1].phase_key = phase_key
          @root.save!
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
          @ctx[:hadoop_job_run1].stopped_at = Time.at(0)
          @ctx[:hadoop_job_run1].stop_reason = "test test"
          @root.save!
        end

        %w[
           /rjn1004/hadoop_job_run1/hadoop_job1
           /rjn1004/hadoop_job_run1/hadoop_job1/Map
           /rjn1004/hadoop_job_run1/hadoop_job1/Reduce
           /rjn1004/hadoop_job_run1/hadoop_job2
           /rjn1004/hadoop_job_run1/hadoop_job2/Map
           /rjn1004/hadoop_job_run1/hadoop_job2/Reduce
        ].each do |name_path|
          it "その子どものhadoop_job, Map, Reduceのstop_reasonもtest testになる" do
            @root.vertex_by_name_path(name_path).stop_reason.should == "test test"
          end
          it "その子どものhadoop_job, Map, Reduceのstopped_atも0になる" do
            @root.vertex_by_name_path(name_path).stopped_at.to_f.should == 0.0
          end
        end
      end
    end

  end

end
