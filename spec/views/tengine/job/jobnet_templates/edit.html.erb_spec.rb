require 'spec_helper'

describe "tengine/job/jobnet_templates/edit.html.erb" do
  before(:each) do
    @jobnet_template = assign(:jobnet_template, stub_model(Tengine::Job::JobnetTemplate,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "MyString",
      :dsl_version => "MyString",
      :lock_version => 1
    ))
  end

  it "renders the edit jobnet_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_jobnet_templates_path(@jobnet_template), :method => "post" do
      assert_select "input#jobnet_template_name", :name => "jobnet_template[name]"
      assert_select "input#jobnet_template_server_name", :name => "jobnet_template[server_name]"
      assert_select "input#jobnet_template_credential_name", :name => "jobnet_template[credential_name]"
      assert_select "input#jobnet_template_killing_signals_text", :name => "jobnet_template[killing_signals_text]"
      assert_select "input#jobnet_template_killing_signal_interval", :name => "jobnet_template[killing_signal_interval]"
      assert_select "input#jobnet_template_description", :name => "jobnet_template[description]"
      assert_select "input#jobnet_template_dsl_version", :name => "jobnet_template[dsl_version]"
      assert_select "input#jobnet_template_lock_version", :name => "jobnet_template[lock_version]"
    end
  end
end
