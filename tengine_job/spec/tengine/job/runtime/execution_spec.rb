# -*- coding: utf-8 -*-
require 'spec_helper'
require 'time'

describe Tengine::Job::Execution do
  describe :actual_estimated_end do
    context "strted_atがnilならnil" do
      subject{ Tengine::Job::Execution.new(:started_at => nil, :estimated_time => 10.minutes) }
      its(:actual_estimated_end) { should == nil }
    end

    context "strted_atが設定されていたらstarted_atに見積もり時間を足した時間" do
      subject do
        Tengine::Job::Execution.new(
          :started_at => Time.parse("2011/10/11 01:00Z"),
          :estimated_time => 10 * 60)
      end
      it { subject.actual_estimated_end.iso8601.should == Time.parse("2011/10/11 01:10Z").iso8601 }
    end
  end



  describe "reset rjn0010" do
    # in [rjn0010]
    #              |-----e2----->(j11)-----e4----->|
    # [S1]--e1-->[F1]                            [J1]--e7-->[E1]
    #              |--e3-->(j12)--e5-->(j13)--e6-->|
    before do
      Tengine::Job::Vertex.delete_all
      builder = Rjn00102jobsAnd1jobParallelJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Execution.create!({
          :root_jobnet_id => @root.id,
          :retry => true, :spot => false,
        })
      @base_props = {
        :execution_id => @execution.id.to_s,
        :root_jobnet_id => @root.id.to_s,
        :target_jobnet_id => @root.id.to_s,
      }
      mock_event = mock(:event)
      mock_event.stub(:occurred_at).and_return{ Time.now }
      mock_event.stub(:[]).with(:execution_id).and_return(@execution.id.to_s)
      @signal = Tengine::Job::Signal.new(mock_event)
    end

    context "全て正常終了した後に" do
      before do
        [:root, :j11, :j12, :j13].each{|j| @ctx[j].phase_key = :success}
        @root.edges.each{|edge| edge.phase_key = :transmitted }
        @root.save!
        @execution.stub(:root_jobnet).and_return(@root)
      end

      context 'target_actualでジョブを取得' do
        it "値を設定している場合" do
          @execution.target_actual_ids = [@ctx[:j12].id.to_s]
          @execution.save!
          @execution.target_actuals.map(&:id).should == [@ctx[:j12].id]
        end

        it '設定していない場合' do
          @execution.target_actual_ids = []
          @execution.save!
          @execution.target_actuals.map(&:id).should == [@ctx[:root].id]
        end
      end

      it "全てのedgeとvetexは初期化される" do
        @execution.transmit(@signal)
        @root.save!
        @execution.save!
        @root.reload
        @execution.reload
        @root.phase_key.should == :ready
        [:j11, :j12, :j13].each{|j| [j, @ctx[j].phase_key].should == [j, :initialized]}
        @root.edges.each{|edge| edge.phase_key.should == :active }
      end

      it "一部再実行の為にreset" do
        @execution.target_actual_ids = [@ctx[:j12].id.to_s]
        @execution.save!
        @execution.transmit(@signal)
        @root.save!
        @execution.save!
        @execution.reload
        @root.reload
        [:root, :j11].each{|j| @ctx[j].phase_key.should == :success}
        [:j12].each{|j| @ctx[j].phase_key.should == :ready}
        [:j13].each{|j| @ctx[j].phase_key.should == :initialized}
        [:e1, :e2, :e3, :e4].each{|n| @ctx[n].phase_key.should == :transmitted }
        [:e5, :e6, :e7].each{|n| @ctx[n].phase_key.should == :active }
      end
    end

  end

end
