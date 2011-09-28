require 'spec_helper'

describe "tengine/job/scripts/new.html.erb" do
  before(:each) do
    assign(:script, stub_model(Tengine::Job::Script,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :script => "MyString"
    ).as_new_record)
  end

  it "renders new script form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_scripts_path, :method => "post" do
      assert_select "input#script_name", :name => "script[name]"
      assert_select "input#script_server_name", :name => "script[server_name]"
      assert_select "input#script_credential_name", :name => "script[credential_name]"
      assert_select "input#script_killing_signals_text", :name => "script[killing_signals_text]"
      assert_select "input#script_killing_signal_interval", :name => "script[killing_signal_interval]"
      assert_select "input#script_script", :name => "script[script]"
    end
  end
end
