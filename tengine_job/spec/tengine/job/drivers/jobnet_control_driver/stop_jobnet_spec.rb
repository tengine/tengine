# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

describe 'stop.jobnet.job.tengine' do
  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../../../../../lib/tengine/job/drivers/jobnet_control_driver.rb", File.dirname(__FILE__))
  driver :jobnet_control_driver

  context "rjn0011" do
    before do
      Tengine::Job::Vertex.delete_all
      builder = Rjn0011NestedForkJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Execution.create!({
          :root_jobnet_id => @root.id,
        })
    end

    context "j1120" do
      before do
        @ctx[:root].tap{|j| j.phase_key = :running}
        @ctx[:j1100].tap{|j| j.phase_key = :running}
        @ctx[:j1110].tap{|j| j.phase_key = :success; j.executing_pid = "1110"}
        [:e1, :e5, :e6].each{|name| @ctx[name].phase_key = :transmitted}
        @base_props = {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @root.id.to_s,
          :root_jobnet_name_path => @root.name_path.to_s,
          :target_jobnet_id => @ctx[:j1120].id.to_s,
          :target_jobnet_name_path => @ctx[:j1120].name_path,
        }
      end

      context "runningの場合" do
        before do
          @ctx[:j1120].tap{|j| j.phase_key = :running}
        end

        context "j1121がinitialized" do
          before do
            @ctx[:j1121].tap{|j| j.phase_key = :initialized}
            [:e10].each{|name| @ctx[name].phase_key = :active}
            @root.save!
          end

          it "j1120をstopすると自身をdyingにして、エッジをcloseして、j1121については何もしません" do
            tengine.should_not_fire
            tengine.receive(:"stop.jobnet.job.tengine",
              :source_name => @ctx[:j1120].name_as_resource,
              :properties => @base_props)
            @root.reload
            @root.phase_key.should == :running
            @ctx.vertex(:j1100).tap{|j| j.phase_key.should == :running}
            @ctx.vertex(:j1110).tap{|j| j.phase_key.should == :success}
            @ctx.vertex(:j1120).tap{|j| j.phase_key.should == :dying}
            @ctx.vertex(:j1121).tap{|j| j.phase_key.should == :initialized}
            [:e1, :e5, :e6].each{|name| @ctx.edge(name).phase_key.should == :transmitted }
            (2..4).each{|idx| [:"e#{idx}", @ctx.edge(:"e#{idx}").phase_key].should == [:"e#{idx}", :active] }
            (7..9).each{|idx| [:"e#{idx}", @ctx.edge(:"e#{idx}").phase_key].should == [:"e#{idx}", :active] }
            (10..11).each{|idx| [:"e#{idx}", @ctx.edge(:"e#{idx}").phase_key].should == [:"e#{idx}", :closing] }
            (12..15).each{|idx| [:"e#{idx}", @ctx.edge(:"e#{idx}").phase_key].should == [:"e#{idx}", :active] }
          end
        end

        [
          [:ready   , :transmitting, :closing],
          [:starting, :transmitted , :transmitted],
          [:running , :transmitted , :transmitted],
        ].each do |(j1121_phase_key, e10_phase_key, e10_new_phase_key)|

          context "j1121が#{j1121_phase_key}" do
            before do
              @ctx[:j1121].tap{|j| j.phase_key = j1121_phase_key}
              [:e10].each{|name| @ctx[name].phase_key = e10_phase_key}
              @root.save!
            end

            [nil, 'user_stop', 'timeout'].each do |stop_reason|
              context "stop_reason: #{stop_reason.inspect}" do
                it "j1120をstopすると自身をdyingにして、エッジをcloseして、j1121についてはstop.job.job.tengineを発火します" do
                  tengine.should_fire(:"stop.job.job.tengine",
                    :source_name => @ctx[:j1121].name_as_resource,
                    :properties => @base_props.merge({
                      :stop_reason => stop_reason,
                      :target_job_id => @ctx[:j1121].id.to_s,
                      :target_job_name_path => @ctx[:j1121].name_path,
                    }))
                  tengine.receive(:"stop.jobnet.job.tengine",
                    :source_name => @ctx[:j1120].name_as_resource,
                    :properties => @base_props.merge({
                        :target_jobnet_id => @ctx[:j1120].id.to_s,
                        :target_jobnet_name_path => @ctx[:j1120].name_path,
                        :stop_reason=>stop_reason,
                      }))
                  @root.reload
                  @root.phase_key.should == :running
                  @ctx.vertex(:j1100).tap{|j| j.phase_key.should == :running}
                  @ctx.vertex(:j1110).tap{|j| j.phase_key.should == :success}
                  @ctx.vertex(:j1120).tap{|j| j.phase_key.should == :dying}
                  @ctx.vertex(:j1121).tap{|j| j.phase_key.should == j1121_phase_key}
                  [:e1, :e5, :e6].each{|name| @ctx.edge(name).phase_key.should == :transmitted }
                  [:e10].each{|name| @ctx.edge(name).phase_key.should == e10_new_phase_key }
                  [:e11].each{|name| @ctx.edge(name).phase_key.should == :closing }
                  (2..4).each{|idx| [:"e#{idx}", @ctx.edge(:"e#{idx}").phase_key].should == [:"e#{idx}", :active] }
                  (7..9).each{|idx| [:"e#{idx}", @ctx.edge(:"e#{idx}").phase_key].should == [:"e#{idx}", :active] }
                  (12..15).each{|idx| [:"e#{idx}", @ctx.edge(:"e#{idx}").phase_key].should == [:"e#{idx}", :active] }
                end
              end
            end

          end
        end

      end
    end

  end


  # in [jn0004]
  #                         |--e3-->(j2)--e5-->|
  # (S1)--e1-->(j1)--e2-->[F1]                [J1]--e7-->(j4)--e8-->(E1)
  #                         |--e4-->(j3)--e6-->|
  #
  # in [jn0004/finally]
  # (S2) --e9-->(jn0004_f)-e10-->(E2)
  #
  context "jn0004" do
    before do
      Tengine::Job::Vertex.delete_all
      builder = Rjn0004ParallelJobnetWithFinally.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Execution.create!({
          :root_jobnet_id => @root.id,
        })
    end

    context "ジョブネットが強制停止された場合" do
      before do
        @ctx[:root].tap{|j| j.phase_key = :dying}
        @ctx[:j1].tap{|j| j.phase_key = :error}
        [:e1, ].each{|name| @ctx[name].phase_key = :transmitted}
        @base_props = {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @root.id.to_s,
          :root_jobnet_name_path => @root.name_path.to_s,
          :target_jobnet_id => @root.id.to_s,
          :target_jobnet_name_path => @root.name_path,
        }
        @root.save!
      end

      it "finallyの親のジョブネットは強制停止中であるため、finallyは動かない" do
        tengine.should_fire(:"error.jobnet.job.tengine",
          :source_name => @ctx[:root].name_as_resource,
          :properties => @base_props)
        tengine.receive(:"error.job.job.tengine",
          :source_name => @ctx[:j1].name_as_resource,
          :properties => @base_props.merge({
              :target_job_id => @ctx[:j1].id.to_s,
              :target_job_name_path => @ctx[:j1].name_path,
            }))
      end
    end

    context "ジョブネットではなくジョブj1が強制停止された場合" do
      before do
        @ctx[:root].tap{|j| j.phase_key = :running} # ジョブネットは強制停止されていません
        @ctx[:j1].tap{|j| j.phase_key = :error}
        [:e1, ].each{|name| @ctx[name].phase_key = :transmitted}
        @base_props = {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @root.id.to_s,
          :root_jobnet_name_path => @root.name_path.to_s,
          :target_jobnet_id => @root.id.to_s,
          :target_jobnet_name_path => @root.name_path,
        }
      end

      it "finallyの親のジョブネットは実行中であるため、finallyは実行される" do
        @root.save!
        tengine.should_fire(:"start.jobnet.job.tengine",
          :source_name => @root.finally_vertex.name_as_resource,
          :properties => @base_props.merge({
              :target_jobnet_id => @root.finally_vertex.id.to_s,
              :target_jobnet_name_path => @root.finally_vertex.name_path,
            }))
        tengine.receive(:"error.job.job.tengine",
          :source_name => @ctx[:j1].name_as_resource,
          :properties => @base_props.merge({
              :target_job_id => @ctx[:j1].id.to_s,
              :target_job_name_path => @ctx[:j1].name_path,
            }))
      end
    end
  end

end
