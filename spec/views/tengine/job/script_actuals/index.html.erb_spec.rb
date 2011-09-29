require 'spec_helper'

describe "tengine/job/script_actuals/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:script_actuals, [
      stub_model(Tengine::Job::ScriptActual,
        :name => "Name",
        :server_name => "Server Name",
        :credential_name => "Credential Name",
        :killing_signals => ["abc", "123"],
        :killing_signal_interval => 1,
        :description => "Description",
        :script => "Script",
        :executing_pid => "Executing Pid",
        :exit_status => "Exit Status",
        :phase_cd => 2,
        :stop_reason => "Stop Reason"
      ),
      stub_model(Tengine::Job::ScriptActual,
        :name => "Name",
        :server_name => "Server Name",
        :credential_name => "Credential Name",
        :killing_signals => ["abc", "123"],
        :killing_signal_interval => 1,
        :description => "Description",
        :script => "Script",
        :executing_pid => "Executing Pid",
        :exit_status => "Exit Status",
        :phase_cd => 2,
        :stop_reason => "Stop Reason"
      )
    ]))
  end

  it "renders a list of tengine_job_script_actuals" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Server Name".to_s, :count => 2
    assert_select "tr>td", :text => "Credential Name".to_s, :count => 2
    assert_select "tr>td", :text => "abc,123", :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Script".to_s, :count => 2
    assert_select "tr>td", :text => "Executing Pid".to_s, :count => 2
    assert_select "tr>td", :text => "Exit Status".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Stop Reason".to_s, :count => 2
  end
end
