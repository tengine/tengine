require 'spec_helper'

describe "tengine/test/sshes/edit.html.erb" do
  before(:each) do
    @ssh = assign(:ssh, stub_model(Tengine::Test::Ssh,
      :host => "MyString",
      :user => "MyString",
      :options => {"a"=>"1", "b"=>"2"},
      :command => "MyString",
      :timeout => 1,
      :stdout => "MyString",
      :stderr => "MyString",
      :error_message => "MyString"
    ))
  end

  it "renders the edit ssh form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_test_sshes_path(@ssh), :method => "post" do
      assert_select "input#ssh_host", :name => "ssh[host]"
      assert_select "input#ssh_user", :name => "ssh[user]"
      assert_select "textarea#ssh_options_yaml", :name => "ssh[options_yaml]"
      assert_select "input#ssh_command", :name => "ssh[command]"
      assert_select "input#ssh_timeout", :name => "ssh[timeout]"
      assert_select "input#ssh_stdout", :name => "ssh[stdout]"
      assert_select "input#ssh_stderr", :name => "ssh[stderr]"
      assert_select "input#ssh_error_message", :name => "ssh[error_message]"
    end
  end
end
