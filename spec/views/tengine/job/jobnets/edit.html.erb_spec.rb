require 'spec_helper'

describe "tengine/job/jobnets/edit.html.erb" do
  before(:each) do
    @jobnet = assign(:jobnet, stub_model(Tengine::Job::Jobnet,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :script => "MyString",
      :description => "MyString",
      :jobnet_type_cd => 1,
      :dsl_version => "MyString",
      :lock_version => 1
    ))
  end

  it "renders the edit jobnet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_jobnets_path(@jobnet), :method => "post" do
      assert_select "input#jobnet_name", :name => "jobnet[name]"
      assert_select "input#jobnet_server_name", :name => "jobnet[server_name]"
      assert_select "input#jobnet_credential_name", :name => "jobnet[credential_name]"
      assert_select "input#jobnet_killing_signals_text", :name => "jobnet[killing_signals_text]"
      assert_select "input#jobnet_killing_signal_interval", :name => "jobnet[killing_signal_interval]"
      assert_select "input#jobnet_script", :name => "jobnet[script]"
      assert_select "input#jobnet_description", :name => "jobnet[description]"
      assert_select "input#jobnet_jobnet_type_cd", :name => "jobnet[jobnet_type_cd]"
      assert_select "input#jobnet_dsl_version", :name => "jobnet[dsl_version]"
      assert_select "input#jobnet_lock_version", :name => "jobnet[lock_version]"
    end
  end
end
