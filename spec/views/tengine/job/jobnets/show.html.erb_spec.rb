require 'spec_helper'

describe "tengine/job/jobnets/show.html.erb" do
  before(:each) do
    @jobnet = assign(:jobnet, stub_model(Tengine::Job::Jobnet,
      :name => "Name",
      :server_name => "Server Name",
      :credential_name => "Credential Name",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "Description",
      :jobnet_type_cd => 1,
      :dsl_version => "Dsl Version",
      :lock_version => 1
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
    rendered.should match(/1/)
    rendered.should match(/Dsl Version/)
    rendered.should match(/1/)
  end
end
