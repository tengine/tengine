require 'spec_helper'

describe "tengine/job/executions/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:executions, [
      stub_model(Tengine::Job::Execution,
        :root_jobnet => nil,
        :target_actual_ids => ["abc", "123"],
        :phase_cd => 1,
        :preparation_command => "Preparation Command",
        :actual_base_timeout_alert => 1,
        :actual_base_timeout_termination => 1,
        :estimated_time => 1,
        :keeping_stdout => false,
        :keeping_stderr => false
      ),
      stub_model(Tengine::Job::Execution,
        :root_jobnet => nil,
        :target_actual_ids => ["abc", "123"],
        :phase_cd => 1,
        :preparation_command => "Preparation Command",
        :actual_base_timeout_alert => 1,
        :actual_base_timeout_termination => 1,
        :estimated_time => 1,
        :keeping_stdout => false,
        :keeping_stderr => false
      )
    ]))
  end

  it "renders a list of tengine_job_executions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "abc,123", :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Preparation Command".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
