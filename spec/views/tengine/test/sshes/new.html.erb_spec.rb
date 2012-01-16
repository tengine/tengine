require 'spec_helper'

describe "tengine/test/sshes/new.html.erb" do
  before(:each) do
    assign(:ssh, stub_model(Tengine::Test::Ssh,
      :host => "MyString",
      :local => false,
      :user => "MyString",
      :options => {"a"=>"1", "b"=>"2"},
      :timeout => 1,
      :command => "MyString",
      :stdout => "MyString",
      :stderr => "MyString",
      :error_message => "MyString"
    ).as_new_record)
  end

  it "renders new ssh form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_test_sshes_path, :method => "post" do
      assert_select "input#ssh_host", :name => "ssh[host]"
      assert_select "input#ssh_local", :name => "ssh[local]"
      assert_select "input#ssh_user", :name => "ssh[user]"
      assert_select "textarea#ssh_options_yaml", :name => "ssh[options_yaml]"
      assert_select "input#ssh_timeout", :name => "ssh[timeout]"
      assert_select "input#ssh_command", :name => "ssh[command]"
      assert_select "input#ssh_stdout", :name => "ssh[stdout]"
      assert_select "input#ssh_stderr", :name => "ssh[stderr]"
      assert_select "input#ssh_error_message", :name => "ssh[error_message]"
    end
  end
end
