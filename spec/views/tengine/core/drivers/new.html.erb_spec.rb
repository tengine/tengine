require 'spec_helper'

describe "tengine/core/driver/new.html.erb" do
  before(:each) do
    assign(:driver, stub_model(Tengine::Core::Driver,
      :name => "MyString",
      :version => "MyString",
      :enabled => false
    ).as_new_record)
  end

  it "renders new driver form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_drivers_path, :method => "post" do
      assert_select "input#driver_name", :name => "driver[name]"
      assert_select "input#driver_version", :name => "driver[version]"
      assert_select "input#driver_enabled", :name => "driver[enabled]"
    end
  end
end
