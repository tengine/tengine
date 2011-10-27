require 'spec_helper'

describe "tengine/core/settings/new.html.erb" do
  before(:each) do
    assign(:setting, stub_model(Tengine::Core::Setting,
      :name => "MyString",
      :value => "MyString"
    ).as_new_record)
  end

  it "renders new setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_settings_path, :method => "post" do
      assert_select "input#setting_name", :name => "setting[name]"
      assert_select "input#setting_value", :name => "setting[value]"
    end
  end
end
