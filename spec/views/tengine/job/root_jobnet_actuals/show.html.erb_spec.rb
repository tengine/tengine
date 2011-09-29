require 'spec_helper'

describe "tengine/job/root_jobnet_actuals/show.html.erb" do
  before(:each) do
    @root_jobnet_actual = assign(:root_jobnet_actual, stub_model(Tengine::Job::RootJobnetActual,
      :name => "Name",
      :server_name => "Server Name",
      :credential_name => "Credential Name",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "Description",
      :script => "Script",
      :jobnet_type_cd => 1,
      :was_expansion => false,
      :phase_cd => 1,
      :stop_reason => "Stop Reason",
      :dsl_version => "Dsl Version",
      :lock_version => 1,
      :template => nil
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
    rendered.should match(/1/)
    rendered.should match(/false/)
    rendered.should match(/1/)
    rendered.should match(/Stop Reason/)
    rendered.should match(/Dsl Version/)
    rendered.should match(/1/)
    rendered.should match(//)
  end
end
