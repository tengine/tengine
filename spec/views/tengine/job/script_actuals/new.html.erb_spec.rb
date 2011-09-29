require 'spec_helper'

describe "tengine/job/script_actuals/new.html.erb" do
  before(:each) do
    assign(:script_actual, stub_model(Tengine::Job::ScriptActual,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "MyString",
      :script => "MyString",
      :executing_pid => "MyString",
      :exit_status => "MyString",
      :phase_cd => 1,
      :stop_reason => "MyString"
    ).as_new_record)
  end

  it "renders new script_actual form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_script_actuals_path, :method => "post" do
      assert_select "input#script_actual_name", :name => "script_actual[name]"
      assert_select "input#script_actual_server_name", :name => "script_actual[server_name]"
      assert_select "input#script_actual_credential_name", :name => "script_actual[credential_name]"
      assert_select "input#script_actual_killing_signals_text", :name => "script_actual[killing_signals_text]"
      assert_select "input#script_actual_killing_signal_interval", :name => "script_actual[killing_signal_interval]"
      assert_select "input#script_actual_description", :name => "script_actual[description]"
      assert_select "input#script_actual_script", :name => "script_actual[script]"
      assert_select "input#script_actual_executing_pid", :name => "script_actual[executing_pid]"
      assert_select "input#script_actual_exit_status", :name => "script_actual[exit_status]"
      assert_select "input#script_actual_phase_cd", :name => "script_actual[phase_cd]"
      assert_select "input#script_actual_stop_reason", :name => "script_actual[stop_reason]"
    end
  end
end
