require 'spec_helper'

describe "tengine/resource/virtual_server_images/show.html.erb" do
  before(:each) do
    @virtual_server_image = assign(:virtual_server_image, stub_model(Tengine::Resource::VirtualServerImage,
      :provider => nil,
      :name => "Name",
      :description => "Description",
      :provided_name => "Provided Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Provided Name/)
  end
end
