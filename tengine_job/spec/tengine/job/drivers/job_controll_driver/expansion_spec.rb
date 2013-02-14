# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

describe 'job_control_driver' do
  include Tengine::RSpec::Extension
  include NetSshMock

  target_dsl File.expand_path("../../../../../lib/tengine/job/runtime/drivers/job_control_driver.rb", File.dirname(__FILE__))
  driver :job_control_driver

  shared_examples_for "/rjn0008/rjn0001/j11を実行する際の環境変数" do |dsl_version|
    it "expansionだったジョブネットよりも上位のジョブの情報は出力されない" do
      @rjn0001 = @root.vertex_by_name_path("/rjn0008/rjn0001")
      @j11 = @root.vertex_by_name_path("/rjn0008/rjn0001/j11")
      @root.phase_key = :running
      @rjn0001.phase_key = :running
      @j11.phase_key = :ready
      @j11.prev_edges.each{|edge| edge.phase_key = :transmitting}
      @root.save!
      @root.reload
      tengine.should_not_fire
      mock_ssh = mock(:ssh)
      Net::SSH.should_receive(:start).
        with("localhost", an_instance_of(Tengine::Resource::Credential), an_instance_of(Hash)).and_yield(mock_ssh)
      mock_channel = mock_channel_fof_script_executable(mock_ssh)
      mock_channel.should_receive(:exec) do |*args|
        args.length.should == 1
        # args.first.should =~ %r<export MM_ACTUAL_JOB_ID=[0-9a-f]{24} MM_ACTUAL_JOB_ANCESTOR_IDS=\\"[0-9a-f]{24}\\" MM_FULL_ACTUAL_JOB_ANCESTOR_IDS=\\"[0-9a-f]{24}\\" MM_ACTUAL_JOB_NAME_PATH=\\"/rjn0001/j11\\" MM_ACTUAL_JOB_SECURITY_TOKEN= MM_SCHEDULE_ID=[0-9a-f]{24} MM_SCHEDULE_ESTIMATED_TIME= MM_TEMPLATE_JOB_ID=[0-9a-f]{24} MM_TEMPLATE_JOB_ANCESTOR_IDS=\\"[0-9a-f]{24}\\" && tengine_job_agent_run -- \$HOME/j11\.sh>
          t_rjn1001 = Tengine::Job::RootJobnetTemplate.find_by_name("rjn0001")
        t_rjn1001.dsl_version.should == dsl_version
        t_j11 = t_rjn1001.vertex_by_name_path("/rjn0001/j11")
        args.first.should =~ %r<MM_TEMPLATE_JOB_ID=#{t_j11.id.to_s}>
          args.first.should_not =~ %r<MM_TEMPLATE_JOB_ANCESTOR_IDS=\"#{@template.id.to_s};#{t_rjn1001.id.to_s}\">
          args.first.should =~ %r<MM_TEMPLATE_JOB_ANCESTOR_IDS=\"#{t_rjn1001.id.to_s}\">
          args.first.should =~ %r<job_test j11>
      end
      tengine.receive("start.job.job.tengine", :properties => {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @root.id.to_s,
          :target_jobnet_id => @rjn0001.id.to_s,
          :target_job_id => @j11.id.to_s,
        })
      @root.reload
      @rjn0001 = @root.vertex_by_name_path("/rjn0008/rjn0001")
      @j11 = @root.vertex_by_name_path("/rjn0008/rjn0001/j11")
      @root.phase_key = :running
      @rjn0001.phase_key = :running
    end
  end

  # in [rjn0008]
  # (S1) --e1-->(rjn0001)--e2-->(rjn0002)--e3-->(E1)
  #
  # in [rjn0001]
  # (S1) --e1-->(j11)--e2-->(j12)--e3-->(E1)
  #
  # in [rjn0002]
  #              |--e2-->(j11)--e4-->|
  # (S1)--e1-->[F1]                [J1]--e6-->(E1)
  #              |--e3-->(j12)--e5-->|
  context "rjn0008" do
    before do
      Tengine::Core::Setting.delete_all
      Tengine::Core::Setting.create!(:name => "dsl_version", :value => "1")
      Tengine::Job::Vertex.delete_all
      Rjn0001SimpleJobnetBuilder.new.create_template
      Rjn0002SimpleParallelJobnetBuilder.new.create_template
      builder = Rjn0008ExpansionFixture.new
      @template = builder.create_template
      @root = @template.generate
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @base_props = {
        :execution_id => @execution.id.to_s,
        :root_jobnet_id => @root.id.to_s,
        :target_jobnet_id => @root.id.to_s,
      }
    end

    it_should_behave_like "/rjn0008/rjn0001/j11を実行する際の環境変数", "1"
  end

  context "複数のバージョンのデータがある場合" do
    before do
      Tengine::Core::Setting.delete_all
      Tengine::Core::Setting.create!(:name => "dsl_version", :value => "2")
      Tengine::Job::Vertex.delete_all
      Rjn0001SimpleJobnetBuilder.new.tap do |f|
        f.create_template(:dsl_version => "1")
        f.create_template(:dsl_version => "2")
      end
      Rjn0002SimpleParallelJobnetBuilder.new.tap do |f|
        f.create_template(:dsl_version => "1")
        f.create_template(:dsl_version => "2")
      end
      builder = Rjn0008ExpansionFixture.new
      builder.create_template(:dsl_version => "1")
      @template = builder.create_template(:dsl_version => "2")
      @root = @template.generate
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @base_props = {
        :execution_id => @execution.id.to_s,
        :root_jobnet_id => @root.id.to_s,
        :target_jobnet_id => @root.id.to_s,
      }
    end

    it_should_behave_like "/rjn0008/rjn0001/j11を実行する際の環境変数", '2'
  end

end


