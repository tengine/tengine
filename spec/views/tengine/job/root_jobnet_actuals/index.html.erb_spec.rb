require 'spec_helper'

describe "tengine/job/root_jobnet_actuals/index.html.erb" do
  before(:each) do
    stub_root_jobnet_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet_template1")
    mock_pagination(assign(:root_jobnet_actuals, [
      stub_model(Tengine::Job::RootJobnetActual,
        :name => "Name",
        :server_name => "Server Name",
        :credential_name => "Credential Name",
        :killing_signals => ["abc", "123"],
        :killing_signal_interval => 1,
        :description => "Description",
        :script => "Script",
        :jobnet_type_cd => 2,
        :was_expansion => false,
        :phase_cd => 3,
        :stop_reason => "Stop Reason",
        :dsl_version => "Dsl Version",
        :lock_version => 4,
        :template => stub_root_jobnet_template
      ),
      stub_model(Tengine::Job::RootJobnetActual,
        :name => "Name",
        :server_name => "Server Name",
        :credential_name => "Credential Name",
        :killing_signals => ["abc", "123"],
        :killing_signal_interval => 1,
        :description => "Description",
        :script => "Script",
        :jobnet_type_cd => 2,
        :was_expansion => false,
        :phase_cd => 3,
        :stop_reason => "Stop Reason",
        :dsl_version => "Dsl Version",
        :lock_version => 4,
        :template => stub_root_jobnet_template
      )
    ]))
  end

  it "renders a list of tengine_job_root_jobnet_actuals" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Server Name".to_s, :count => 2
    assert_select "tr>td", :text => "Credential Name".to_s, :count => 2
    assert_select "tr>td", :text => "abc,123", :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Script".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Stop Reason".to_s, :count => 2
    assert_select "tr>td", :text => "Dsl Version".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "root_jobnet_template1".to_s, :count => 2
  end
end
