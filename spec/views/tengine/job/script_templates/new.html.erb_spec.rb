require 'spec_helper'

describe "tengine/job/script_templates/new.html.erb" do
  before(:each) do
    assign(:script_template, stub_model(Tengine::Job::ScriptTemplate,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :script => "MyString",
      :has_chained_children => false
    ).as_new_record)
  end

  it "renders new script_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_script_templates_path, :method => "post" do
      assert_select "input#script_template_name", :name => "script_template[name]"
      assert_select "input#script_template_server_name", :name => "script_template[server_name]"
      assert_select "input#script_template_credential_name", :name => "script_template[credential_name]"
      assert_select "input#script_template_killing_signals_text", :name => "script_template[killing_signals_text]"
      assert_select "input#script_template_killing_signal_interval", :name => "script_template[killing_signal_interval]"
      assert_select "input#script_template_script", :name => "script_template[script]"
      assert_select "input#script_template_has_chained_children", :name => "script_template[has_chained_children]"
    end
  end
end
