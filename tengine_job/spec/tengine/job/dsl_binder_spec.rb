# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

describe Tengine::Job::DslLoader do
  before(:all) do
    Tengine.plugins.add(Tengine::Job)
    Tengine::Job::Vertex.delete_all
  end

  include Tengine::RSpec::Extension

  target_dsl File.expand_path("dsls/0019_execute_job_on_event.rb", File.dirname(__FILE__))
  driver :job_control_driver


  describe "実行時にジョブを起動するイベントドライバ" do
    context "0019_execute_job_on_event.rb" do

      it do
        mock_execution = mock(:execution, :id => "mock_execution_id")
        Tengine::Job::Execution.should_receive(:create!).and_return(mock_execution)
        tengine.should_fire(:"start.execution.job.tengine", {
            :properties=>{
              :execution_id => mock_execution.id.to_s,
              :root_jobnet_id => an_instance_of(BSON::ObjectId),
              :target_jobnet_id => an_instance_of(BSON::ObjectId),
            }
          })
        tengine.receive("foo")
      end
    end

  end

end
