require 'spec_helper'

describe "tengine/test/scripts/edit.html.erb" do
  before(:each) do
    @script = assign(:script, stub_model(Tengine::Test::Script,
      :kind => "MyString",
      :code => "MyString",
      :options => {"a"=>"1", "b"=>"2"},
      :timeout => 1,
      :messages => {"a"=>"1", "b"=>"2"}
    ))
  end

  it "renders the edit script form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_test_scripts_path(@script), :method => "post" do
      assert_select "input#script_kind", :name => "script[kind]"
      assert_select "input#script_code", :name => "script[code]"
      assert_select "textarea#script_options_yaml", :name => "script[options_yaml]"
      assert_select "input#script_timeout", :name => "script[timeout]"
      assert_select "textarea#script_messages_yaml", :name => "script[messages_yaml]"
    end
  end
end
