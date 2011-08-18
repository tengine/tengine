require 'spec_helper'

describe "tengine/core/drivers/index.html.erb" do
  before(:each) do
    assign(:drivers, [
      stub_model(Tengine::Core::Driver,
        :name => "Name",
        :version => "Version",
        :enabled => false
      ),
      stub_model(Tengine::Core::Driver,
        :name => "Name",
        :version => "Version",
        :enabled => false
      )
    ])
  end

  it "renders a list of tengine_core_drivers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Version".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
