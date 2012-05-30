require 'spec_helper'

describe "tengine/job/executions/edit.html.erb" do
  before(:each) do
    @execution = assign(:execution, stub_model(Tengine::Job::Execution,
      :root_jobnet => nil,
      :target_actual_ids => ["abc", "123"],
      :phase_cd => 1,
      :preparation_command => "MyString",
      :actual_base_timeout_alert => 1,
      :actual_base_timeout_termination => 1,
      :estimated_time => 1,
      :keeping_stdout => false,
      :keeping_stderr => false
    ))
  end

  it "renders the edit execution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_executions_path(@execution), :method => "post" do
      assert_select "input#execution_root_jobnet_id", :name => "execution[root_jobnet_id]"
      assert_select "input#execution_target_actual_ids_text", :name => "execution[target_actual_ids_text]"
      assert_select "input#execution_phase_cd", :name => "execution[phase_cd]"
      assert_select "input#execution_preparation_command", :name => "execution[preparation_command]"
      assert_select "input#execution_actual_base_timeout_alert", :name => "execution[actual_base_timeout_alert]"
      assert_select "input#execution_actual_base_timeout_termination", :name => "execution[actual_base_timeout_termination]"
      assert_select "input#execution_estimated_time", :name => "execution[estimated_time]"
      assert_select "input#execution_keeping_stdout", :name => "execution[keeping_stdout]"
      assert_select "input#execution_keeping_stderr", :name => "execution[keeping_stderr]"
    end
  end
end
