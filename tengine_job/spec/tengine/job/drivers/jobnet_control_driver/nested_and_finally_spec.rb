# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

describe 'jobnet_control_driver' do
  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../../../../../lib/tengine/job/runtime/drivers/jobnet_control_driver.rb", File.dirname(__FILE__))
  driver :jobnet_control_driver

  # in [rjn0012]
  # (S1)--e1-->[j1000]--e2-->[j2000]--e3-->(E1)
  #
  # in [j1000]
  # (S2)--e4-->[j1100]--e5-->[j1200]--e6-->(E2)
  #
  # in [j1100]
  # (S3)--e7-->(j1110)--e8-->(E3)
  #
  # in [j1200]
  # (S4)--e9-->(j1210)--e10-->(E4)
  #
  # in [j1000:finally (=j1f00)]
  # (S5)--e11-->[j1f10]--e12-->(E5)
  #
  # in [j1f10]
  # (S6)--e13-->(j1f11)--e14-->(E6)
  #
  # in [j1000:finally:finally (=j1ff0)]
  # (S7)--e15-->(j1ff1)--e16-->(E7)
  #
  # in [j2000]
  # (S8)--e17-->(j2100)--e18-->(E8)
  #
  # in [jf000:finally (=jf000)]
  # (S9)--e19-->(jf100)--e20-->(E9)
  #
  context "rjn0012" do
    before do
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0012NestedAndFinallyBuilder.new
      @root = builder.create_actual
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
    end

    context "j1100が終了して" do
      it "j1100が成功した場合、j1200を実行するイベントが発火される" do
        @root.phase_key = :running
        @ctx.vertex(:j1000).phase_key = :running
        @ctx.vertex(:j1100).phase_key = :success
        @ctx.vertex(:j1110).phase_key = :success
        @ctx.vertex(:j1200).phase_key = :initialized
        @ctx.vertex(:j1000).finally_vertex.phase_key = :initialized
        [:e1, :e4, :e7, :e8].each{|name| @ctx.edge(name).phase_key = :transmitted}
        @root.save!
        tengine.should_fire(:"start.jobnet.job.tengine",
          :source_name => @ctx[:j1200].name_as_resource,
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1200].id.to_s,
            :target_jobnet_name_path => @ctx[:j1200].name_path,
          }))
        tengine.receive(:"success.jobnet.job.tengine",
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1100].id.to_s,
            :target_jobnet_name_path => @ctx[:j1100].name_path,
          }))
        @root.reload
        [:e1, :e4, :e5, :e7, :e8].each{|name| @ctx.edge(name).phase_key = :transmitted}
        [:e2, :e3, :e6          ].each{|name| @ctx.edge(name).phase_key = :active     }
        @ctx.vertex(:j1100).phase_key.should == :success
        @ctx.vertex(:j1200).phase_key.should == :ready
        @ctx.vertex(:j1000).finally_vertex.phase_key.should == :initialized
      end

      it "j1100が失敗した場合、j1200ではなく、j1f00が実行するイベントが発火される" do
        @root.phase_key = :running
        @ctx.vertex(:j1000).phase_key = :running
        @ctx.vertex(:j1100).phase_key = :error
        @ctx.vertex(:j1110).phase_key = :error
        @ctx.vertex(:j1200).phase_key = :initialized
        @ctx.vertex(:j1000).finally_vertex.phase_key = :initialized
        [:e1, :e4, :e7].each{ |name| @ctx.edge(name).phase_key = :transmitted}
        [:e8          ].each{ |name| @ctx.edge(name).phase_key = :closed     }
        [:e5, :e6     ].each{ |name| @ctx.edge(name).phase_key = :active     }
        @root.save!
        tengine.should_fire(:"start.jobnet.job.tengine",
          :source_name => @ctx[:j1000].finally_vertex.name_as_resource,
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1000].finally_vertex.id.to_s,
            :target_jobnet_name_path => @ctx[:j1000].finally_vertex.name_path,
          }))
        tengine.receive(:"error.jobnet.job.tengine",
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1100].id.to_s,
            :target_jobnet_name_path => @ctx[:j1100].name_path,
          }))
        @root.reload
        [:e1, :e4, :e7].each{ |name| [name, @ctx.edge(name).phase_key].should == [name, :transmitted]}
        [:e5, :e6, :e8].each{ |name| [name, @ctx.edge(name).phase_key].should == [name, :closed     ]}
        [:e2, :e3     ].each{ |name| [name, @ctx.edge(name).phase_key].should == [name, :closing    ]}
        @ctx.vertex(:j1100).phase_key.should == :error
        @ctx.vertex(:j1200).phase_key.should == :initialized
        @ctx.vertex(:j1000).finally_vertex.phase_key.should == :ready
      end
    end

    context "j1200が終了して、j1f00が実行される" do
      it "j1200が成功した場合、j1f00が実行するイベントが発火される" do
        @root.phase_key = :running
        @ctx.vertex(:j1000).phase_key = :running
        @ctx.vertex(:j1100).phase_key = :success
        @ctx.vertex(:j1110).phase_key = :success
        @ctx.vertex(:j1200).phase_key = :success
        @ctx.vertex(:j1210).phase_key = :success
        @ctx.vertex(:j1000).finally_vertex.phase_key = :initialized
        [:e1, :e4, :e5, :e7, :e8, :e9, :e10].each{|name| @ctx.edge(name).phase_key = :transmitted}
        [:e2, :e3, :e6,                    ].each{|name| @ctx.edge(name).phase_key = :active     }
        @root.save!
        tengine.should_fire(:"start.jobnet.job.tengine",
          :source_name => @ctx[:j1000].finally_vertex.name_as_resource,
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1000].finally_vertex.id.to_s,
            :target_jobnet_name_path => @ctx[:j1000].finally_vertex.name_path,
          }))
        tengine.receive(:"success.jobnet.job.tengine", :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1200].id.to_s,
            :target_jobnet_name_path => @ctx[:j1200].name_path,
          }))
        @root.reload
        [:e1, :e4, :e5, :e6, :e7, :e8, :e9, :e10].each{|name| @ctx.edge(name).phase_key = :transmitted}
        [:e2, :e3                               ].each{|name| @ctx.edge(name).phase_key = :active     }
        @ctx.vertex(:j1100).phase_key.should == :success
        @ctx.vertex(:j1110).phase_key.should == :success
        @ctx.vertex(:j1200).phase_key.should == :success
        @ctx.vertex(:j1210).phase_key.should == :success
        @ctx.vertex(:j1000).finally_vertex.phase_key.should == :ready
      end

      it "j1200が失敗した場合、j1f00が実行するイベントが発火される" do
        @root.phase_key = :running
        @ctx.vertex(:j1000).phase_key = :running
        @ctx.vertex(:j1100).phase_key = :success
        @ctx.vertex(:j1110).phase_key = :success
        @ctx.vertex(:j1200).phase_key = :error
        @ctx.vertex(:j1210).phase_key = :error
        @ctx.vertex(:j1000).finally_vertex.phase_key = :initialized
        [:e1, :e4, :e5, :e7, :e8, :e9].each{|name| @ctx.edge(name).phase_key = :transmitted}
        [:e10                        ].each{|name| @ctx.edge(name).phase_key = :closed     }
        @root.save!
        tengine.should_fire(:"start.jobnet.job.tengine",
          :source_name => @ctx[:j1000].finally_vertex.name_as_resource,
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1000].finally_vertex.id.to_s,
            :target_jobnet_name_path => @ctx[:j1000].finally_vertex.name_path,
          }))
        tengine.receive(:"error.jobnet.job.tengine",
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1200].id.to_s,
            :target_jobnet_name_path => @ctx[:j1200].name_path,
          }))
        @root.reload
        [:e1, :e4, :e5, :e7, :e8].each{|name| @ctx.edge(name).phase_key = :transmitted}
        [:e6, :e10              ].each{|name| @ctx.edge(name).phase_key = :closed     }
        [:e2, :e3               ].each{|name| @ctx.edge(name).phase_key = :active     }
        @ctx.vertex(:j1100).phase_key.should == :success
        @ctx.vertex(:j1110).phase_key.should == :success
        @ctx.vertex(:j1200).phase_key.should == :error
        @ctx.vertex(:j1210).phase_key.should == :error
        @ctx.vertex(:j1000).finally_vertex.phase_key.should == :ready
      end
    end

    context "j1f00が終了" do
      it "j1f00が成功した場合" do
        @root.phase_key = :running
        @ctx.vertex(:j1000).phase_key = :running
        @ctx.vertex(:j1100).phase_key = :success
        @ctx.vertex(:j1110).phase_key = :success
        @ctx.vertex(:j1200).phase_key = :success
        @ctx.vertex(:j1210).phase_key = :success
        @ctx.vertex(:j1000).finally_vertex.phase_key = :success
        @ctx.vertex(:j1000).finally_vertex.finally_vertex.phase_key = :success
        @ctx.vertex(:j1ff1).phase_key = :success
        [:e2, :e3, :e17, :e18, :e19, :e20].each{|name| @ctx.edge(name).phase_key = :active     }
        [:e1, :e4, :e5, :e6, :e7, :e8, :e9, :e10, :e11, :e12, :e13, :e14, :e15, :e16].
          each{|name| @ctx.edge(name).phase_key = :transmitted}
        @root.save!
        tengine.should_fire(:"success.jobnet.job.tengine",
          :source_name => @ctx[:j1000].name_as_resource,
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1000].id.to_s,
            :target_jobnet_name_path => @ctx[:j1000].name_path,
          }))
        tengine.receive(:"success.jobnet.job.tengine",
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx.vertex(:j1000).finally_vertex.id.to_s,
            :target_jobnet_name_path => @ctx.vertex(:j1000).finally_vertex.name_path,
          }))
        @root.reload
        [:e2, :e3, :e17, :e18, :e19, :e20].each{|name| @ctx.edge(name).phase_key.should == :active     }
        [:e1, :e4, :e5, :e6, :e7, :e8, :e9, :e10, :e11, :e12, :e13, :e14, :e15, :e16].
          each{|name| @ctx.edge(name).phase_key.should == :transmitted}
        @ctx.vertex(:j1100).phase_key.should == :success
        @ctx.vertex(:j1110).phase_key.should == :success
        @ctx.vertex(:j1200).phase_key.should == :success
        @ctx.vertex(:j1210).phase_key.should == :success
        @ctx.vertex(:j1000).finally_vertex.phase_key.should == :success
        @ctx.vertex(:j2000).phase_key.should == :initialized
      end

      it "j1000が成功した場合" do
        @root.phase_key = :running
        @ctx[:j1000].phase_key = :success
        @ctx[:j1100].phase_key = :success
        @ctx[:j1110].phase_key = :success
        @ctx[:j1200].phase_key = :success
        @ctx[:j1210].phase_key = :success
        @ctx[:j1000].finally_vertex.phase_key = :success
        @ctx[:j1000].finally_vertex.finally_vertex.phase_key = :success
        @ctx[:j1ff1].phase_key = :success
        [:e2, :e3, :e17, :e18, :e19, :e20].each{|name| @ctx[name].phase_key = :active     }
        [:e1, :e4, :e5, :e6, :e7, :e8, :e9, :e10, :e11, :e12, :e13, :e14, :e15, :e16].
          each{|name| @ctx[name].phase_key = :transmitted}
        @root.save!
        tengine.should_fire(:"start.jobnet.job.tengine",
          :source_name => @ctx[:j2000].name_as_resource,
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx.vertex(:j2000).id.to_s,
            :target_jobnet_name_path => @ctx.vertex(:j2000).name_path,
          }))
        tengine.receive(:"success.jobnet.job.tengine",
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx.vertex(:j1000).id.to_s,
            :target_jobnet_name_path => @ctx.vertex(:j1000).name_path,
          }))
        @root.reload
        [:e3, :e17, :e18, :e19, :e20].each{|name| @ctx.edge(name).phase_key.should == :active     }
        [:e2  ].each{|name| @ctx.edge(name).phase_key.should == :transmitting     }
        [:e1, :e4, :e5, :e6, :e7, :e8, :e9, :e10, :e11, :e12, :e13, :e14, :e15, :e16].
          each{|name| @ctx.edge(name).phase_key.should == :transmitted}
        @ctx.vertex(:j1100).phase_key.should == :success
        @ctx.vertex(:j1110).phase_key.should == :success
        @ctx.vertex(:j1200).phase_key.should == :success
        @ctx.vertex(:j1210).phase_key.should == :success
        @ctx.vertex(:j1000).finally_vertex.phase_key.should == :success
        @ctx.vertex(:j2000).phase_key.should == :ready
      end

      it "j1f00が失敗した場合" do
        @root.phase_key = :running
        @ctx.vertex(:j1000).phase_key = :running
        @ctx.vertex(:j1100).phase_key = :success
        @ctx.vertex(:j1110).phase_key = :success
        @ctx.vertex(:j1200).phase_key = :success
        @ctx.vertex(:j1210).phase_key = :success
        @ctx.vertex(:j1000).finally_vertex.phase_key = :error
        @ctx.vertex(:j1000).finally_vertex.finally_vertex.phase_key = :error
        @ctx.vertex(:j1ff1).phase_key = :error
        [:e2, :e3, :e17, :e18, :e19, :e20].each{|name| @ctx.edge(name).phase_key = :active     }
        [:e12, :e16].each{|name| @ctx.edge(name).phase_key = :closed}
        [:e1, :e4, :e5, :e6, :e7, :e8, :e9, :e10, :e11, :e13, :e14, :e15].
          each{|name| @ctx.edge(name).phase_key = :transmitted}
        @root.save!
        tengine.should_fire(:"error.jobnet.job.tengine",
          :source_name => @ctx[:j1000].name_as_resource,
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:j1000].id.to_s,
            :target_jobnet_name_path => @ctx[:j1000].name_path,
          }))
        tengine.receive(:"error.jobnet.job.tengine",
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx.vertex(:j1000).finally_vertex.id.to_s,
            :target_jobnet_name_path => @ctx.vertex(:j1000).finally_vertex.name_path,
          }))
        @root.reload
        [:e2, :e3, :e17, :e18, :e19, :e20].each{|name| @ctx.edge(name).phase_key.should == :active     }
        [:e12, :e16].each{|name| @ctx.edge(name).phase_key.should == :closed}
        [:e1, :e4, :e5, :e6, :e7, :e8, :e9, :e10, :e11, :e13, :e14, :e15].
          each{|name| @ctx.edge(name).phase_key.should == :transmitted}
        @ctx.vertex(:j1100).phase_key.should == :success
        @ctx.vertex(:j1110).phase_key.should == :success
        @ctx.vertex(:j1200).phase_key.should == :success
        @ctx.vertex(:j1210).phase_key.should == :success
        @ctx.vertex(:j1000).finally_vertex.phase_key.should == :error
        @ctx.vertex(:j1000).finally_vertex.finally_vertex.phase_key.should == :error
        @ctx.vertex(:j1ff1).phase_key.should == :error
        @root.finally_vertex.phase_key.should == :initialized
      end
    end

  end


  context "rjn0005" do
    before do
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0005RetryTwoLayerFixture.new
      @root = builder.create_actual
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
    end

    all_edge_names = (1..26).map{|idx| :"e#{idx}"}

    context "j41がエラーになったことをjn4で受けた場合" do
      it "以降のvertexがclosedになる" do
        @root.phase_key = :running
        @ctx[:j1].phase_key = :success
        @ctx[:j2].phase_key = :success
        @ctx[:j4].phase_key = :initialized
        @ctx[:jn4].phase_key = :running
        @ctx[:j41].phase_key = :error
        [
          :j42, :j43, :j44,
          :jn4f, :jn4_f,
          :finally, :jn0005_fjn, :jn0005_f, :jn0005_fjn,
          :jn0005_f1, :jn0005_f2, :jn0005_fjn_f,  :jn0005_fif
        ].each do |key|
          @ctx[key].phase_key = :initialized
        end
        transmitted_edges = [:e1, :e2, :e3, :e4, :e9]
        transmitted_edges.each{|name| @ctx[name].phase_key = :transmitted}
        (all_edge_names - transmitted_edges).each{|name| @ctx[name].phase_key = :active}
        @root.save!
        tengine.should_fire(:"start.jobnet.job.tengine",
          :source_name => @ctx[:jn4f].name_as_resource,
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:jn4f].id.to_s,
            :target_jobnet_name_path => @ctx[:jn4f].name_path,
          }))
        tengine.receive(:"error.job.job.tengine",
          :properties => @base_props.merge({
            :target_jobnet_id => @ctx[:jn4].id.to_s,
            :target_jobnet_name_path => @ctx[:jn4].name_path,
            :target_job_id => @ctx[:j41].id.to_s,
            :target_job_name_path => @ctx[:j41].name_path,
          }))

        @root.reload
        [
          :j42, :j43, :j44,
          :jn4_f,
          :finally, :jn0005_fjn, :jn0005_f, :jn0005_fjn,
          :jn0005_f1, :jn0005_f2, :jn0005_fjn_f,  :jn0005_fif
        ].each do |key|
          @ctx[key].phase_key.should == :initialized
        end
        transmitted_edges = [:e1, :e2, :e3, :e4, :e9]
        transmitted_edges.each{|name| @ctx.edge(name).phase_key.should == :transmitted}
        closed_edges = [
          :e10, :e11, :e12, :e13, :e14, :e15, :e16, # jn4のedge
        ]
        closing_edges = [
          :e6, :e7, :e8, # rootのedge
        ]
        closed_edges.each{|name| [name, @ctx.edge(name).phase_key].should == [name, :closed]}
        (all_edge_names - transmitted_edges - closed_edges - closing_edges).
          each{|name| [name, @ctx.edge(name).phase_key].should == [name, :active]}
        @root.phase_key.should == :running

        expected_job_phases = {
          :j1 => :success,
          :j2 => :success,
          :j4 => :initialized,
          :jn4 => :running,
          :j41 => :error,
          :jn4f => :initialized,
        }

        actual_job_phases = expected_job_phases.keys.inject({}) do |d, key|
          d[key] = @ctx[key].phase_key
          d
        end

        actual_job_phases.should == expected_job_phases
      end
    end

    context "j41がエラーになって、jn4_fを実行中に、j2が失敗した場合" do
      it "jn4の終了を待ってからfinallyが実行される" do
        @root.phase_key = :running
        @ctx[:j1].phase_key = :success
        @ctx[:j2].phase_key = :error
        @ctx[:j4].phase_key = :initialized
        @ctx[:jn4].phase_key = :running
        @ctx[:jn4f].phase_key = :running
        @ctx[:jn4_f].phase_key = :running
        @ctx[:j41].phase_key = :error
        [
          :j42, :j43, :j44,
          :finally, :jn0005_fjn, :jn0005_f, :jn0005_fjn,
          :jn0005_f1, :jn0005_f2, :jn0005_fjn_f,  :jn0005_fif
        ].each do |key|
          @ctx[key].phase_key = :initialized
        end
        transmitted_edges = [:e1, :e2, :e3, :e4, :e9, :e17]
        transmitted_edges.each{|name| @ctx[name].phase_key = :transmitted}
        closed_edges = [:e10, :e11, :e12, :e13, :e14, :e15, :e16] # jn4のedge
        closed_edges.each{|name| @ctx.edge(name).phase_key = :closed}
        closing_edges = [:e6, :e7, :e8] # rootのedge
        closing_edges.each{|name| @ctx.edge(name).phase_key = :closing}
        (all_edge_names - transmitted_edges - closed_edges - closing_edges).
          each{|name| @ctx[name].phase_key = :active}
        @root.save!
        tengine.should_not_fire
        tengine.receive(:"error.job.job.tengine",
          :properties => @base_props.merge({
            :target_jobnet_id => @root.id.to_s,
            :target_jobnet_name_path => @root.name_path,
            :target_job_id => @ctx[:j2].id.to_s,
            :target_job_name_path => @ctx[:j2].name_path,
          }))

        @root.reload
        [
          :j42, :j43, :j44,
          :finally, :jn0005_fjn, :jn0005_f, :jn0005_fjn,
          :jn0005_f1, :jn0005_f2, :jn0005_fjn_f,  :jn0005_fif
        ].each do |key|
          @ctx[key].phase_key.should == :initialized
        end
        transmitted_edges = [:e1, :e2, :e3, :e4, :e9, :e17]
        transmitted_edges.each{|name| @ctx.edge(name).phase_key.should == :transmitted}
        closed_edges = [:e10, :e11, :e12, :e13, :e14, :e15, :e16, :e5, ] # jn4のedge + j2の後
        closed_edges.each{|name| [name, @ctx.edge(name).phase_key].should == [name, :closed]}
        closing_edges = [:e6, :e7, :e8] # rootのedge
        closing_edges.each{|name| [name, @ctx.edge(name).phase_key].should == [name, :closing]}
        (all_edge_names - transmitted_edges - closed_edges - closing_edges).
          each{|name| [name, @ctx.edge(name).phase_key].should == [name, :active]}
        @root.phase_key.should == :running

        expected_job_phases = {
          :j1 => :success,
          :j2 => :error,
          :j4 => :initialized,
          :jn4 => :running,
          :jn4f => :running,
          :jn4_f => :running,
          :j41 => :error,
        }

        actual_job_phases = expected_job_phases.keys.inject({}) do |d, key|
          d[key] = @ctx[key].phase_key
          d
        end

        actual_job_phases.should == expected_job_phases
      end

    end
  end

end
