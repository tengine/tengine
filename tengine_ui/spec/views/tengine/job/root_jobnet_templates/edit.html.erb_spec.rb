require 'spec_helper'

describe "tengine/job/root_jobnet_templates/edit.html.erb" do
  before(:each) do
    @root_jobnet_template = assign(:root_jobnet_template, stub_model(Tengine::Job::Template::RootJobnet,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "MyString",
      :script => "MyString",
      :jobnet_type_cd => 1,
      :category => nil,
      :lock_version => 1,
      :dsl_filepath => "MyString",
      :dsl_lineno => 1,
      :dsl_version => "MyString"
    ))
  end

  it "renders the edit root_jobnet_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_root_jobnet_templates_path(@root_jobnet_template), :method => "post" do
      assert_select "input#root_jobnet_template_name", :name => "root_jobnet_template[name]"
      assert_select "input#root_jobnet_template_server_name", :name => "root_jobnet_template[server_name]"
      assert_select "input#root_jobnet_template_credential_name", :name => "root_jobnet_template[credential_name]"
      assert_select "input#root_jobnet_template_killing_signals_text", :name => "root_jobnet_template[killing_signals_text]"
      assert_select "input#root_jobnet_template_killing_signal_interval", :name => "root_jobnet_template[killing_signal_interval]"
      assert_select "input#root_jobnet_template_description", :name => "root_jobnet_template[description]"
      assert_select "input#root_jobnet_template_script", :name => "root_jobnet_template[script]"
      assert_select "input#root_jobnet_template_jobnet_type_cd", :name => "root_jobnet_template[jobnet_type_cd]"
      assert_select "input#root_jobnet_template_category_id", :name => "root_jobnet_template[category_id]"
      assert_select "input#root_jobnet_template_lock_version", :name => "root_jobnet_template[lock_version]"
      assert_select "input#root_jobnet_template_dsl_filepath", :name => "root_jobnet_template[dsl_filepath]"
      assert_select "input#root_jobnet_template_dsl_lineno", :name => "root_jobnet_template[dsl_lineno]"
      assert_select "input#root_jobnet_template_dsl_version", :name => "root_jobnet_template[dsl_version]"
    end
  end
end
