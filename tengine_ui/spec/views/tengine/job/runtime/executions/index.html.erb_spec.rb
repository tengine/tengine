# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/runtime/executions/index.html.erb" do
  before(:each) do
    root_jobnet = stub_model(Tengine::Job::Runtime::RootJobnet, :name => "root_jobnet1")
    mock_pagination(assign(:executions, [
      stub_model(Tengine::Job::Runtime::Execution,
        :root_jobnet => root_jobnet,
        :target_actual_ids => ["abc", "123"],
        :phase_name => "稼働中",
        :preparation_command => "Preparation Command",
        :actual_base_timeout_alert => 2,
        :actual_base_timeout_termination => 3,
        :estimated_time => 4,
        :keeping_stdout => true,
        :keeping_stderr => false
      ),
      stub_model(Tengine::Job::Runtime::Execution,
        :root_jobnet => root_jobnet,
        :target_actual_ids => ["abc", "123"],
        :phase_name => "稼働中",
        :preparation_command => "Preparation Command",
        :actual_base_timeout_alert => 2,
        :actual_base_timeout_termination => 3,
        :estimated_time => 4,
        :keeping_stdout => true,
        :keeping_stderr => false
      )
    ]))
  end

  it "renders a list of tengine_job_runtime_executions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "root_jobnet1", :count => 2
    assert_select "tr>td", :text => "abc,123", :count => 2
    assert_select "tr>td", :text => "稼働中".to_s, :count => 2
  end
end
