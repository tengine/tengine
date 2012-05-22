# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::RootJobnetActual do

  context :update_with_lock do
    before do
      Tengine::Job::Vertex.delete_all
      builder = Rjn0001SimpleJobnetBuilder.new
      builder.create_actual
      @ctx = builder.context
    end

    it "updateで更新できる" do
      root = @ctx[:root]
      j11 = root.find_descendant(@ctx[:j11].id)
      j11.executing_pid = "1111"
      root.save!
      #
      loaded = Tengine::Job::RootJobnetActual.find(root.id)
      loaded.find_descendant(@ctx[:j11].id).executing_pid.should == "1111"
    end

    it "update_with_lockで更新できる" do
      count = 0
      root = @ctx[:root]
      root.update_with_lock do
        count += 1
        j11 = root.find_descendant(@ctx[:j11].id)
        j11.executing_pid = "1111"
      end
      count.should == 1
      #
      loaded = Tengine::Job::RootJobnetActual.find(root.id)
      loaded.find_descendant(@ctx[:j11].id).executing_pid.should == "1111"
    end
  end


  describe :rerun do
    before do
      Tengine::Job::Execution.delete_all
      Tengine::Job::Vertex.delete_all
      builder = Rjn0001SimpleJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @root.phase_key = :error
      @ctx[:e1].phase_key = :transmitted
      @ctx[:j11].phase_key = :success
      @ctx[:e2].phase_key = :transmitted
      @ctx[:j12].phase_key = :error
      @ctx[:e3].phase_key = :active
      @root.save!
      @execution.phase_key = :error
      @execution.save!
    end

    context "rerunするとExecutionが別に作られて、それを実行するイベントが発火される" do
      [true, false].each do |spot|

        it "スポット実行 #{spot.inspect}" do
          execution1 = Tengine::Job::Execution.new(:retry => true, :spot => spot,
            :root_jobnet_id => @root.id,
            :target_actual_ids => [@ctx[:j12].id])
          Tengine::Job::Execution.should_receive(:new).with({
              :retry => true, :spot => spot,
              :root_jobnet_id => @root.id
            }).and_return(execution1)
          sender = mock(:sender)
          sender.should_receive(:wait_for_connection).and_yield
          sender.should_receive(:fire).with(:'start.execution.job.tengine',
            :properties => {
              :execution_id => execution1.id.to_s,
            })
          expect{
            execution = @root.rerun(@ctx[:j12].id, :spot => spot, :sender => sender)
            execution.id.should_not == @execution.id # rerunの戻り値のexecutionは元々のexecutionとは別物です
          }.to change(Tengine::Job::Execution, :count).by(1)
        end
      end

    end

  end

  describe "#stop" do
    let :valid_attributes do
      {
        :name => "test1",
        :started_at => Time.new(2011, 11, 7, 13, 0)
      }
    end

    before do
      EM.should_receive(:run).and_yield
      @mock_sender = mock(:sender)
      Tengine::Event.stub(:default_sender).and_return(@mock_sender)
    end

    it "destroys the requested root_jobnet_actual" do
      root_jobnet_actual = Tengine::Job::RootJobnetActual.create! valid_attributes
      @mock_sender.should_receive(:fire).with(:"stop.jobnet.job.tengine", an_instance_of(Hash)) do |_, fire_options|
        fire_options[:properties].should be_a(Hash)
        fire_options[:properties][:stop_reason].should == "user_stop"
      end
      root_jobnet_actual.stop
    end

    it "redirects to the tengine_job_root_jobnet_actuals list" do
      root_jobnet_actual = Tengine::Job::RootJobnetActual.create! valid_attributes
      @mock_sender.should_receive(:fire).with(:"stop.jobnet.job.tengine", an_instance_of(Hash)) do |_, fire_options|
        fire_options[:properties].should be_a(Hash)
        fire_options[:properties][:stop_reason].should == "user_stop"
      end
      root_jobnet_actual.stop
    end
  end

end
