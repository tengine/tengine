require 'spec_helper'

describe "tengine/core/drivers/edit.html.erb" do
  before(:each) do
    @driver = assign(:driver, stub_model(Tengine::Core::Driver,
      :name => "MyString",
      :version => "MyString",
      :enabled => false,
      :enabled_on_activation => false
    ))
  end

  it "renders the edit driver form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_drivers_path(@driver), :method => "post" do
      assert_select "input#driver_name", :name => "driver[name]"
      assert_select "input#driver_version", :name => "driver[version]"
      assert_select "input#driver_enabled", :name => "driver[enabled]"
      assert_select "input#driver_enabled_on_activation", :name => "driver[enabled_on_activation]"
    end
  end
end
