require 'spec_helper'

describe "tengine/job/jobnet_actuals/new.html.erb" do
  before(:each) do
    assign(:jobnet_actual, stub_model(Tengine::Job::JobnetActual,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "MyString",
      :dsl_version => "MyString",
      :lock_version => 1,
      :was_expansion => false,
      :phase_cd => 1,
      :stop_reason => "MyString"
    ).as_new_record)
  end

  it "renders new jobnet_actual form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_jobnet_actuals_path, :method => "post" do
      assert_select "input#jobnet_actual_name", :name => "jobnet_actual[name]"
      assert_select "input#jobnet_actual_server_name", :name => "jobnet_actual[server_name]"
      assert_select "input#jobnet_actual_credential_name", :name => "jobnet_actual[credential_name]"
      assert_select "input#jobnet_actual_killing_signals_text", :name => "jobnet_actual[killing_signals_text]"
      assert_select "input#jobnet_actual_killing_signal_interval", :name => "jobnet_actual[killing_signal_interval]"
      assert_select "input#jobnet_actual_description", :name => "jobnet_actual[description]"
      assert_select "input#jobnet_actual_dsl_version", :name => "jobnet_actual[dsl_version]"
      assert_select "input#jobnet_actual_lock_version", :name => "jobnet_actual[lock_version]"
      assert_select "input#jobnet_actual_was_expansion", :name => "jobnet_actual[was_expansion]"
      assert_select "input#jobnet_actual_phase_cd", :name => "jobnet_actual[phase_cd]"
      assert_select "input#jobnet_actual_stop_reason", :name => "jobnet_actual[stop_reason]"
    end
  end
end
