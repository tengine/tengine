require 'spec_helper'

describe "tengine/resource/virtual_server_images/new.html.erb" do
  before(:each) do
    assign(:virtual_server_image, stub_model(Tengine::Resource::VirtualServerImage,
      :provider => nil,
      :name => "MyString",
      :description => "MyString",
      :provided_id => "MyString"
    ).as_new_record)
  end

  it "renders new virtual_server_image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_virtual_server_images_path, :method => "post" do
      assert_select "input#virtual_server_image_provider_id", :name => "virtual_server_image[provider_id]"
      assert_select "input#virtual_server_image_name", :name => "virtual_server_image[name]"
      assert_select "input#virtual_server_image_description", :name => "virtual_server_image[description]"
      assert_select "input#virtual_server_image_provided_id", :name => "virtual_server_image[provided_id]"
    end
  end
end
