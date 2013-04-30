# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

describe Tengine::Job::Dsl::Loader do
  before(:all) do
    Tengine.plugins.add(Tengine::Job)
    Tengine::Job::Template::Vertex.delete_all
  end

  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../../dsls/0019_execute_job_on_event.rb", __FILE__)
  driver :job_control_driver


  describe "実行時にジョブを起動するイベントドライバ" do
    context "0019_execute_job_on_event.rb" do

      it do
        mock_execution = mock(:execution, :id => "mock_execution_id")
        Tengine::Job::Runtime::Execution.should_receive(:create!).and_return(mock_execution)
        tengine.should_fire(:"start.execution.job.tengine", {
            :properties=>{
              :execution_id => mock_execution.id.to_s,
              :root_jobnet_id => an_instance_of(Moped::BSON::ObjectId),
              :target_jobnet_id => an_instance_of(Moped::BSON::ObjectId),
            }
          })
        tengine.receive("foo")
      end
    end

  end

end
