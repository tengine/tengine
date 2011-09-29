require 'spec_helper'

describe "tengine/job/script_templates/edit.html.erb" do
  before(:each) do
    @script_template = assign(:script_template, stub_model(Tengine::Job::ScriptTemplate,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "MyString",
      :script => "MyString"
    ))
  end

  it "renders the edit script_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_script_templates_path(@script_template), :method => "post" do
      assert_select "input#script_template_name", :name => "script_template[name]"
      assert_select "input#script_template_server_name", :name => "script_template[server_name]"
      assert_select "input#script_template_credential_name", :name => "script_template[credential_name]"
      assert_select "input#script_template_killing_signals_text", :name => "script_template[killing_signals_text]"
      assert_select "input#script_template_killing_signal_interval", :name => "script_template[killing_signal_interval]"
      assert_select "input#script_template_description", :name => "script_template[description]"
      assert_select "input#script_template_script", :name => "script_template[script]"
    end
  end
end
