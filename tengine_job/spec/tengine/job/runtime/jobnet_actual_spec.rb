# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::Runtime::Jobnet do

  describe :human_phase_key do
    human_phase_name_hash = {
      :initialized=>"初期化済",
      :ready=>"準備中",
      :starting=>"開始中",
      :running=>"実行中",
      :dying=>"強制停止中",
      :success=>"正常終了",
      :error=>"エラー終了",
      :stuck=>"状態不明",
      :stopping_by_user => "強制停止中",
      :stopped_by_user => "強制停止済",
      :stopping_by_timeout => "タイムアウト強制停止中",
      :stopped_by_timeout => "タイムアウト強制停止済",
    }.freeze

    before(:all) do
      I18n.backend ||= I18n::Backend::Simple.new
      @i18_locale_backup = I18n.locale
      I18n.locale = :ja
      I18n.backend.store_translations('ja',
        'selectable_attrs' => {'tengine/job/jobnet_actual' => {'human_phase_name' => human_phase_name_hash } })
    end

    after(:all) do
      I18n.locale = @i18_locale_backup
    end

    (Tengine::Job::Runtime::Jobnet.phase_keys - [:dying, :error]).each do |phase_key|
      context "#{phase_key.inspect}の場合" do
        subject{ Tengine::Job::Runtime::Jobnet.new(:phase_key => phase_key) }
        its(:human_phase_key){ should == phase_key } # 変わらない
        its(:human_phase_name){ should == human_phase_name_hash[phase_key] }
      end
    end

    context "phase_keyが:dyingの場合" do
      subject{ Tengine::Job::Runtime::Jobnet.new(:phase_key => :dying) }
      its(:human_phase_key){ should == :dying }
      its(:human_phase_name){ should == human_phase_name_hash[:dying] }
      context "stop_reasonがuser_stopならば" do
        before{ subject.stop_reason = "user_stop" }
        its(:human_phase_key){ should == :stopping_by_user }
        its(:human_phase_name){ should == human_phase_name_hash[:stopping_by_user] }
      end
      context "stop_reasonがtimeoutならば" do
        before{ subject.stop_reason = "timeout" }
        its(:human_phase_key){ should == :stopping_by_timeout }
        its(:human_phase_name){ should == human_phase_name_hash[:stopping_by_timeout] }
      end
    end

    context "phase_keyが:errorの場合" do
      subject{ Tengine::Job::Runtime::Jobnet.new(:phase_key => :error) }
      its(:human_phase_key){ should == :error }
      its(:human_phase_name){ should == human_phase_name_hash[:error] }
      context "stop_reasonがuser_stopならば" do
        before{ subject.stop_reason = "user_stop" }
        its(:human_phase_key){ should == :stopped_by_user }
        its(:human_phase_name){ should == human_phase_name_hash[:stopped_by_user] }
      end
      context "stop_reasonがtimeoutならば" do
        before{ subject.stop_reason = "timeout" }
        its(:human_phase_key){ should == :stopped_by_timeout }
        its(:human_phase_name){ should == human_phase_name_hash[:stopped_by_timeout] }
      end
    end
  end

  describe "reset rjn0010" do
    # in [rjn0010]
    #              |-----e2----->(j11)-----e4----->|
    # [S1]--e1-->[F1]                            [J1]--e7-->[E1]
    #              |--e3-->(j12)--e5-->(j13)--e6-->|
    before do
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn00102jobsAnd1jobParallelJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @base_props = {
        :execution_id => @execution.id.to_s,
        :root_jobnet_id => @root.id.to_s,
        :target_jobnet_id => @root.id.to_s,
      }
      mock_event = mock(:event)
      mock_event.stub(:[]).with(:execution_id).and_return(@execution.id.to_s)
      @signal = Tengine::Job::Runtime::Signal.new(mock_event)
    end

    shared_examples_for "全て再実行するためにrootをリセット" do
      it "全てのedgeとvetexは初期化される" do
        @root.reset(@signal)
        @signal.process_callbacks
        @root.save!
        @root.reload
        [:root, :j11, :j12, :j13].each{|j| [j, @ctx[j].phase_key].should == [j, :initialized]}
        @root.edges.each{|edge| edge.phase_key.should == :active }
      end
    end

    context "全て正常終了した後に" do
      before do
        [:root, :j11, :j12, :j13].each{|j| @ctx[j].phase_key = :success}
        @root.edges.each{|edge| edge.phase_key = :transmitted }
        @root.save!
      end

      it_should_behave_like "全て再実行するためにrootをリセット"

      it "一部再実行の為にreset" do
        @ctx[:j12].reset(@signal)
        @signal.process_callbacks
        @root.save!
        @root.reload
        [:root, :j11].each{|j| @ctx[j].phase_key.should == :success}
        [:j12, :j13].each{|j| @ctx[j].phase_key.should == :initialized}
        [:e1, :e2, :e3, :e4].each{|n| @ctx[n].phase_key.should == :transmitted }
        [:e5, :e6, :e7].each{|n| @ctx[n].phase_key.should == :active }
      end
    end

    context "異常終了した後に" do
      before do
        [:root, :j12].each{|j| @ctx[j].phase_key = :error}
        [:j11].each{|j| @ctx[j].phase_key = :success}
        [:j13].each{|j| @ctx[j].phase_key = :initialized}
        [:e1, :e2, :e3, :e4].each{|n| @ctx[n].phase_key = :transmitted }
        [:e5, :e6, :e7].each{|n| @ctx[n].phase_key = :active }
        @root.save!
      end

      it_should_behave_like "全て再実行するためにrootをリセット"

      it "j11をreset" do
        @ctx[:j11].reset(@signal)
        @signal.process_callbacks
        @root.save!
        @root.reload
        [:root, :j12].each{|j| [j, @ctx[j].phase_key].should == [j, :error]}
        [:j11, :j13].each{|j| @ctx[j].phase_key.should == :initialized}
        [:e1, :e2, :e3].each{|n| @ctx[n].phase_key.should == :transmitted }
        [:e4, :e5, :e6, :e7].each{|n| @ctx[n].phase_key.should == :active }
      end

      it "j12をreset" do
        @ctx[:j12].reset(@signal)
        @signal.process_callbacks
        @root.save!
        @root.reload
        [:root, ].each{|j| [j, @ctx[j].phase_key].should == [j, :error]}
        [:j11, ].each{|j| @ctx[j].phase_key.should == :success}
        [:j12, :j13].each{|j| @ctx[j].phase_key.should == :initialized}
        [:e1, :e2, :e3, :e4].each{|n| @ctx[n].phase_key.should == :transmitted }
        [:e5, :e6, :e7].each{|n| @ctx[n].phase_key.should == :active }
      end

      it "j13をreset" do
        @ctx[:j13].reset(@signal)
        @signal.process_callbacks
        @root.save!
        @root.reload
        [:root, :j12, ].each{|j| [j, @ctx[j].phase_key].should == [j, :error]}
        [:j11, ].each{|j| @ctx[j].phase_key.should == :success}
        [:j13].each{|j| @ctx[j].phase_key.should == :initialized}
        [:e1, :e2, :e3, :e4].each{|n| @ctx[n].phase_key.should == :transmitted }
        [:e5, :e6, :e7].each{|n| @ctx[n].phase_key.should == :active }
      end
    end
  end

  describe "#fire_stop_event" do
    before do
      EM.should_receive(:run).and_yield
      @mock_sender = mock(:sender)
      Tengine::Event.stub(:default_sender).and_return(@mock_sender)
    end

    let :valid_attributes do
      {:name => "test1"}
    end

    let :valid_attributes_for_root do
      {:name => "root test1"}
    end

    it "destroys the requested jobnet_actual" do
      root_jobnet_actual = \
        Tengine::Job::Runtime::RootJobnet.create! valid_attributes_for_root
      jobnet_actual = Tengine::Job::Runtime::Jobnet.create! valid_attributes
      job_actual = Tengine::Job::Runtime::Jobnet.create! valid_attributes
      jobnet_actual.stub(:children).and_return([job_actual])
      Tengine::Job::Runtime::RootJobnet.any_instance.stub(:find_descendant).
        and_return(jobnet_actual)
      @mock_sender.should_receive(:fire).with(:"stop.jobnet.job.tengine", an_instance_of(Hash)) do |_, fire_options|
        fire_options[:properties].should be_a(Hash)
        fire_options[:properties][:stop_reason].should == "user_stop"
      end
      jobnet_actual.fire_stop_event root_jobnet_actual
    end

    it "destroys the requested actual job. example: job, hadoop_job_run (script_executable? => true)" do
      root_jobnet_actual = \
        Tengine::Job::Runtime::RootJobnet.create! valid_attributes_for_root
      jobnet_actual = Tengine::Job::Runtime::Jobnet.create! valid_attributes
      job_actual = Tengine::Job::Runtime::Jobnet.create! valid_attributes
      # job_actual.stub(:children).and_return(nil)
      job_actual.stub(:script_executable?).and_return(true)
      job_actual.stub(:parent).and_return(jobnet_actual)
      Tengine::Job::Runtime::RootJobnet.any_instance.stub(:find_descendant).
        and_return(job_actual)
      @mock_sender.should_receive(:fire).with(:"stop.job.job.tengine", an_instance_of(Hash)) do |_, fire_options|
        fire_options[:properties].should be_a(Hash)
        fire_options[:properties][:stop_reason].should == "user_stop"
      end
      job_actual.fire_stop_event root_jobnet_actual
    end

    it "destroys to the tengine_job_jobnet_actuals list. example: jobnet (script_executable? => false)" do
      root_jobnet_actual = \
        Tengine::Job::Runtime::RootJobnet.create! valid_attributes_for_root
      jobnet_actual = Tengine::Job::Runtime::Jobnet.create! valid_attributes
      job_actual = Tengine::Job::Runtime::Jobnet.create! valid_attributes
      # jobnet_actual.stub(:children).and_return([job_actual])
      jobnet_actual.stub(:script_executable?).and_return(false)
      Tengine::Job::Runtime::RootJobnet.any_instance.stub(:find_descendant).
        and_return(jobnet_actual)
      @mock_sender.should_receive(:fire).with(:"stop.jobnet.job.tengine", an_instance_of(Hash)) do |_, fire_options|
        fire_options[:properties].should be_a(Hash)
        fire_options[:properties][:stop_reason].should == "user_stop"
      end
      jobnet_actual.fire_stop_event root_jobnet_actual
    end
  end
end
