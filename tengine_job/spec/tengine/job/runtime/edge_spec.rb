# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::Runtime::Edge do

  before do
    @now = Time.now.utc
    @event = mock(:event, :occurred_at => @now)
    @execution = mock(:execution,
      :id => "execution_id",
      :estimated_time => 600,
      :actual_estimated_end => Time.utc(2011,10,27,19,8),
      :preparation_command => nil)
    @execution.stub!(:retry).and_return(false) # 再実行ではないという設定
    @execution.stub!(:in_scope?).with(any_args).and_return(true)
    @signal = Tengine::Job::Runtime::Signal.new(@event)
    @signal.stub!(:execution).and_return(@execution)
  end

  describe :transmit do
    context "シンプルなケース" do
      # in [rjn0001]
      # (S1) --e1-->(j11)--e2-->(j12)--e3-->(E1)
      before do
        builder = Rjn0001SimpleJobnetBuilder.new
        builder.create_actual
        @ctx = builder.context
      end

      it "e1をtransmitするとtransmitting、j11はactivateされてreadyになり、イベントが通知されるのを待つ" do
        @ctx[:e1].phase_key = :active
        @ctx[:j11].phase_key = :initialized
        @ctx[:root].save!
        @ctx[:e1].transmit(@signal)
        @signal.process_callbacks
        @ctx[:e1].phase_key.should == :transmitting
        @ctx[:j11].phase_key.should == :ready
        @signal.reservations.length.should == 1
        reservation = @signal.reservations.first
        reservation.event_type_name.should == :"start.job.job.tengine"
        reservation.options[:properties][:target_jobnet_id].should == @ctx[:root].id.to_s
        reservation.options[:properties][:target_job_id].should == @ctx[:j11].id.to_s
        reservation.options[:source_name].should =~ %r<^job:.+/\d+/#{@ctx[:root].id.to_s}/#{@ctx[:j11].id.to_s}$>
      end

      it "j11がactivateされると、e1はcompleteされてtransmittedになり、j11はstartingになる" do
        @ctx[:root].phase_key = :starting
        @ctx[:e1].phase_key = :transmitting
        @ctx[:j11].phase_key = :ready
        @ctx[:root].save!
        @ctx[:j11].should_receive(:execute)
        @execution.should_receive(:signal=).with(@signal)
        @execution.stub(:retry).and_return(false)
        @ctx[:j11].activate(@signal)
        @signal.callbacks.should_not be_empty
        @signal.process_callbacks
        @ctx[:e1].phase_key.should == :transmitted
        @ctx[:j11].phase_key.should == :starting
        @signal.reservations.length.should == 0
      end
    end

    context "分岐するケース" do
      # in [rjn0002]
      #              |--e2-->(j11)--e4-->|
      # (S1)--e1-->[F1]                [J1]--e6-->(E1)
      #              |--e3-->(j12)--e5-->|
      before do
        builder = Rjn0002SimpleParallelJobnetBuilder.new
        builder.create_actual
        @ctx = builder.context
      end

      it "e1をtransmitするとe1はtransmitted,e2とe3はtransmittingでj11とj12はreadyになる" do
        [:e1, :e2, :e3].each{|name| @ctx[name].phase_key = :active}
        @ctx[:j11].phase_key = :initialized
        @ctx[:j12].phase_key = :initialized
        @ctx[:root].save!

        @ctx[:root].update_with_lock do
        @ctx[:e1].transmit(@signal)
        # @ctx[:root].save!
        end
        @signal.process_callbacks
        @ctx[:root].reload
        @ctx.edge(:e1).phase_key.should == :transmitted
        @ctx.edge(:e2).phase_key.should == :transmitting
        @ctx.edge(:e3).phase_key.should == :transmitting
        @ctx.vertex(:j11).tap{|j| j.reload; j.phase_key.should == :ready}
        @ctx.vertex(:j12).phase_key.should == :ready
        @signal.reservations.length.should == 2
        @signal.reservations.first.tap do |r|
          r.event_type_name.should == :"start.job.job.tengine"
          r.options[:properties][:target_jobnet_id].should == @ctx[:root].id.to_s
          r.options[:properties][:target_job_id].should == @ctx[:j11].id.to_s
          r.options[:source_name].should =~ %r<^job:.+/\d+/#{@ctx[:root].id.to_s}/#{@ctx[:j11].id.to_s}$>
        end
        @signal.reservations.last.tap do |r|
          r.event_type_name.should == :"start.job.job.tengine"
          r.options[:properties][:target_jobnet_id].should == @ctx[:root].id.to_s
          r.options[:properties][:target_job_id].should == @ctx[:j12].id.to_s
          r.options[:source_name].should =~ %r<^job:.+/\d+/#{@ctx[:root].id.to_s}/#{@ctx[:j12].id.to_s}$>
        end
      end

      it "e4をtransmitするとtransmittedになるけどe6は変わらず" do
        [:e4, :e5, :e6].each{|name| @ctx[name].phase_key = :active}
        @ctx[:root].save!
        @ctx[:e4].transmit(@signal)
        @signal.process_callbacks
        @ctx[:root].save!
        @ctx[:root].reload
        @ctx[:e4].phase_key.should == :transmitted
        @ctx[:e5].phase_key.should == :active
        @ctx[:e6].phase_key.should == :active
        @signal.reservations.should be_empty
      end

      it "e4をtransmitした後、e5をtransmitするとe6もtransmittedになる" do
        @ctx[:root].phase_key = :running
        @ctx[:e4].phase_key = :transmitted
        @ctx[:e5].phase_key = :active
        @ctx[:e6].phase_key = :active
        @ctx[:J1].should_not be_new_record
        @ctx[:root].save!
        @ctx[:e5].transmit(@signal)
        @signal.process_callbacks
        @ctx[:root].save!
        @ctx[:root].reload
        @ctx.edge(:e4).phase_key.should == :transmitted
        @ctx.edge(:e5).phase_key.should == :transmitted
        @ctx.edge(:e6).phase_key.should == :transmitted
        @ctx.vertex(:J1).activatable?.should == true
        @signal.reservations.first.tap do |r|
          r.event_type_name.should == :"success.jobnet.job.tengine"
          r.options[:properties][:target_jobnet_id].should == @ctx[:root].id.to_s
        end
      end
    end

    context "forkとjoinが直接組み合わされるケース" do
      # in [rjn0003]
      #                                                |--e7-->(j14)--e11-->(j16)--e14--->|
      #              |--e2-->(j11)--e4-->(j13)--e6-->[F2]                                 |
      # (S1)--e1-->[F1]                                |--e8-->[J1]--e12-->(j17)--e15-->[J2]--e16-->(E2)
      #              |                                 |--e9-->[J1]                       |
      #              |--e3-->(j12)------e5---------->[F3]                                 |
      #                                                |--e10---->(j15)---e13------------>|
      before do
        builder = Rjn0003ForkJoinJobnetBuilder.new
        builder.create_actual
        @ctx = builder.context
      end

      it "e6.transmitしてもe12には伝搬しない" do
        [:e5, :e6, :e7, :e8, :e9, :e10, :e12].each{|name| @ctx[name].phase_key = :active}
        [:j14, :j15, :j17].each{|name| @ctx[name].phase_key = :initialized}
        @ctx[:root].save!
        @ctx[:e6].transmit(@signal)
        @signal.process_callbacks
        @ctx[:e6].phase_key.should == :transmitted
        @ctx[:e7].phase_key.should == :transmitting
        @ctx[:e8].phase_key.should == :transmitted
        @ctx[:e12].phase_key.should == :active
        @ctx[:j14].phase_key.should == :ready
        @signal.reservations.length.should == 1
        @signal.reservations.first.tap do |r|
          r.event_type_name.should == :"start.job.job.tengine"
          r.options[:properties][:target_jobnet_id].should == @ctx[:root].id.to_s
          r.options[:properties][:target_job_id].should == @ctx[:j14].id.to_s
          r.options[:source_name].should =~ %r<^job:.+/\d+/#{@ctx[:root].id.to_s}/#{@ctx[:j14].id.to_s}$>
        end
      end

      it "e5とe6の両方をtransmitするとe12に伝搬する" do
        [:e5, :e9, :e10, :e12].each{|name| @ctx[name].phase_key = :active}
        @ctx[:e6].phase_key = :transmitted
        @ctx[:e7].phase_key = :transmitting
        @ctx[:e8].phase_key = :transmitted
        [:j14].each{|name| @ctx[name].phase_key = :ready}
        [:j15, :j17].each{|name| @ctx[name].phase_key = :initialized}
        @ctx[:root].save!
        @signal.reservations.clear
        @ctx[:e5].transmit(@signal)
        @signal.process_callbacks
        @ctx[:e6].phase_key.should == :transmitted
        @ctx[:e7].phase_key.should == :transmitting
        @ctx[:e8].phase_key.should == :transmitted
        @ctx[:e9].phase_key.should == :transmitted
        @ctx[:e10].phase_key.should == :transmitting
        @ctx[:e12].phase_key.should == :transmitting
        @signal.reservations.length.should == 2
        @signal.reservations.first.tap do |r|
          r.event_type_name.should == :"start.job.job.tengine"
          r.options[:properties][:target_jobnet_id].should == @ctx[:root].id.to_s
          r.options[:properties][:target_job_id].should == @ctx[:j17].id.to_s
        end
        @signal.reservations.last.tap do |r|
          r.event_type_name.should == :"start.job.job.tengine"
          r.options[:properties][:target_jobnet_id].should == @ctx[:root].id.to_s
          r.options[:properties][:target_job_id].should == @ctx[:j15].id.to_s
        end
      end

    end

  end

  context "<BUG>再実行したジョブが準備中のままになってしまう" do

    before :all do
      @test_sshd = TestSshd.new.launch
      TestSshdResource.instance = TestSshdResource.new(@test_sshd)
    end

    after :all do
      TestSshdResource.instance = nil
      TestSshd.kill_launched_processes
    end

    # in [jn0004]
    #                         |--e3-->(j2)--e5-->|
    # (S1)--e1-->(j1)--e2-->[F1]                [J1]--e7-->(j4)--e8-->(E1)
    #                         |--e4-->(j3)--e6-->|
    #
    # in [jn0004/finally]
    # (S2) --e9-->(jn0004_f)-e10-->(E2)
    before do
      Tengine::Resource::Server.delete_all
      Tengine::Resource::Credential.delete_all
      builder = Rjn0004ParallelJobnetWithFinally.new
      builder.create_actual
      @ctx = builder.context
    end

    context "j1が失敗するとe2以降のedgeはclosedになる。" do
      before do
        [:e1].each{|name| @ctx[name].phase_key = :transmitted}
        [:e2, :e3, :e4, :e5, :e6, :e7, :e8].each{|name| @ctx[name].phase_key = :closed}
        [:root, :j1].each{|name| @ctx[name].phase_key = :error}
        [:j2].each{|name| @ctx[name].phase_key = :ready}
        [:j3, :j4].each{|name| @ctx[name].phase_key = :initialized}
        @ctx[:root].save!
      end

      it "j2以降を再実行しようとしてclosedのe3に対してcompleteしても問題なく動けばOK" do
        @now = Time.now.utc
        @event = mock(:event, :occurred_at => @now)
        @execution = mock(:execution,
          :id => "execution_id",
          :estimated_time => 600,
          :retry => true,
          :spot => true,
          :target_actual_ids => [@ctx[:j2].id.to_s],
          :actual_estimated_end => Time.utc(2011,10,27,19,8),
          :preparation_command => "export J2_FAIL=true")
        @execution.should_receive(:ack).with(an_instance_of(Tengine::Job::Runtime::Signal))
        @signal = Tengine::Job::Runtime::Signal.new(@event)
        @execution.stub(:signal=).with(@signal)
        @execution.stub(:signal).and_return(@signal)
        @signal.stub!(:execution).and_return(@execution)
        @ctx.vertex(:j2).activate(@signal)
        @signal.process_callbacks
      end
    end
  end

end
