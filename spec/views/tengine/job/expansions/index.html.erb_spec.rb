require 'spec_helper'

describe "tengine/job/expansions/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:expansions, [
      stub_model(Tengine::Job::Expansion,
        :name => "Name",
        :server_name => "Server Name",
        :credential_name => "Credential Name",
        :killing_signals => ["abc", "123"],
        :killing_signal_interval => 1
      ),
      stub_model(Tengine::Job::Expansion,
        :name => "Name",
        :server_name => "Server Name",
        :credential_name => "Credential Name",
        :killing_signals => ["abc", "123"],
        :killing_signal_interval => 1
      )
    ]))
  end

  it "renders a list of tengine_job_expansions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Server Name".to_s, :count => 2
    assert_select "tr>td", :text => "Credential Name".to_s, :count => 2
    assert_select "tr>td", :text => "abc,123", :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
