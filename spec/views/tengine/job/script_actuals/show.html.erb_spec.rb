require 'spec_helper'

describe "tengine/job/script_actuals/show.html.erb" do
  before(:each) do
    @script_actual = assign(:script_actual, stub_model(Tengine::Job::ScriptActual,
      :name => "Name",
      :server_name => "Server Name",
      :credential_name => "Credential Name",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "Description",
      :script => "Script",
      :executing_pid => "Executing Pid",
      :exit_status => "Exit Status",
      :phase_cd => 1,
      :stop_reason => "Stop Reason"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Server Name/)
    rendered.should match(/Credential Name/)
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML("abc,123"))}/)
    rendered.should match(/1/)
    rendered.should match(/Description/)
    rendered.should match(/Script/)
    rendered.should match(/Executing Pid/)
    rendered.should match(/Exit Status/)
    rendered.should match(/1/)
    rendered.should match(/Stop Reason/)
  end
end
