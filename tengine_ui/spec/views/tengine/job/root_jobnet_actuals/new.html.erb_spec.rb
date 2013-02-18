require 'spec_helper'

describe "tengine/job/root_jobnet_actuals/new.html.erb" do
  before(:each) do
    assign(:root_jobnet_actual, stub_model(Tengine::Job::Runtime::RootJobnet,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "MyString",
      :script => "MyString",
      :jobnet_type_cd => 1,
      :executing_pid => "MyString",
      :exit_status => "MyString",
      :was_expansion => false,
      :phase_cd => 1,
      :stop_reason => "MyString",
      :category => nil,
      :lock_version => 1,
      :template => nil
    ).as_new_record)
  end

  it "renders new root_jobnet_actual form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_root_jobnet_actuals_path, :method => "post" do
      assert_select "input#root_jobnet_actual_name", :name => "root_jobnet_actual[name]"
      assert_select "input#root_jobnet_actual_server_name", :name => "root_jobnet_actual[server_name]"
      assert_select "input#root_jobnet_actual_credential_name", :name => "root_jobnet_actual[credential_name]"
      assert_select "input#root_jobnet_actual_killing_signals_text", :name => "root_jobnet_actual[killing_signals_text]"
      assert_select "input#root_jobnet_actual_killing_signal_interval", :name => "root_jobnet_actual[killing_signal_interval]"
      assert_select "input#root_jobnet_actual_description", :name => "root_jobnet_actual[description]"
      assert_select "input#root_jobnet_actual_script", :name => "root_jobnet_actual[script]"
      assert_select "input#root_jobnet_actual_jobnet_type_cd", :name => "root_jobnet_actual[jobnet_type_cd]"
      assert_select "input#root_jobnet_actual_executing_pid", :name => "root_jobnet_actual[executing_pid]"
      assert_select "input#root_jobnet_actual_exit_status", :name => "root_jobnet_actual[exit_status]"
      assert_select "input#root_jobnet_actual_was_expansion", :name => "root_jobnet_actual[was_expansion]"
      assert_select "input#root_jobnet_actual_phase_cd", :name => "root_jobnet_actual[phase_cd]"
      assert_select "input#root_jobnet_actual_stop_reason", :name => "root_jobnet_actual[stop_reason]"
      assert_select "input#root_jobnet_actual_category_id", :name => "root_jobnet_actual[category_id]"
      assert_select "input#root_jobnet_actual_lock_version", :name => "root_jobnet_actual[lock_version]"
      assert_select "input#root_jobnet_actual_template_id", :name => "root_jobnet_actual[template_id]"
    end
  end
end
