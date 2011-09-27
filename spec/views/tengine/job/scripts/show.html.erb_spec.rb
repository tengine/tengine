require 'spec_helper'

describe "tengine/job/scripts/show.html.erb" do
  before(:each) do
    @script = assign(:script, stub_model(Tengine::Job::Script,
      :name => "Name",
      :server_name => "Server Name",
      :credential_name => "Credential Name",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :script => "Script",
      :has_chained_children => false
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
    rendered.should match(/Script/)
    rendered.should match(/false/)
  end
end
