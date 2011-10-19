# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/root_jobnet_actuals/index.html.erb" do
  before(:each) do
    stub_category = stub_model(Tengine::Job::Category, :caption => "カテゴリ1")
    stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
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
        :executing_pid => "Executing Pid",
        :exit_status => "Exit Status",
        :was_expansion => false,
        :phase_cd => 3,
        :stop_reason => "Stop Reason",
        :category => stub_category,
        :lock_version => 4,
        :template => stub_template
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
        :executing_pid => "Executing Pid",
        :exit_status => "Exit Status",
        :was_expansion => false,
        :phase_cd => 3,
        :stop_reason => "Stop Reason",
        :category => stub_category,
        :lock_version => 4,
        :template => stub_template
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
    assert_select "tr>td", :text => "Executing Pid".to_s, :count => 2
    assert_select "tr>td", :text => "Exit Status".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Stop Reason".to_s, :count => 2
    assert_select "tr>td", :text => "カテゴリ1", :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "root_jobnet1", :count => 2
  end
end
