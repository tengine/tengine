require 'spec_helper'

describe "tengine/test/scripts/new.html.erb" do
  before(:each) do
    assign(:script, stub_model(Tengine::Test::Script,
      :code => "MyString",
      :result => "MyString",
      :message => "MyString"
    ).as_new_record)
  end

  it "renders new script form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_test_scripts_path, :method => "post" do
      assert_select "input#script_code", :name => "script[code]"
      assert_select "input#script_result", :name => "script[result]"
      assert_select "input#script_message", :name => "script[message]"
    end
  end
end
