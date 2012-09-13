require 'spec_helper'

describe "tengine/job/expansions/show.html.erb" do
  before(:each) do
    @expansion = assign(:expansion, stub_model(Tengine::Job::Expansion,
      :name => "Name",
      :server_name => "Server Name",
      :credential_name => "Credential Name",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Server Name/)
    rendered.should match(/Credential Name/)
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape("abc,123"))}/)
    rendered.should match(/1/)
    rendered.should match(/Description/)
  end
end
