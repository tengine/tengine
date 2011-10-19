require 'spec_helper'

describe "tengine/resource/virtual_server_images/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:virtual_server_images, [
      stub_model(Tengine::Resource::VirtualServerImage,
        :provider => nil,
        :name => "Name",
        :description => "Description",
        :provided_name => "Provided Name"
      ),
      stub_model(Tengine::Resource::VirtualServerImage,
        :provider => nil,
        :name => "Name",
        :description => "Description",
        :provided_name => "Provided Name"
      )
    ]))
  end

  it "renders a list of tengine_resource_virtual_server_images" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Provided Name".to_s, :count => 2
  end
end
