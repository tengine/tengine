require 'spec_helper'

describe "tengine/resource/virtual_server_types/new.html.erb" do
  before(:each) do
    assign(:virtual_server_type, stub_model(Tengine::Resource::VirtualServerType,
      :provider => nil,
      :provided_id => "MyString",
      :properties => {"a"=>"1", "b"=>"2"},
      :caption => "MyString"
    ).as_new_record)
  end

  it "renders new virtual_server_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_virtual_server_types_path, :method => "post" do
      assert_select "input#virtual_server_type_provider_id", :name => "virtual_server_type[provider_id]"
      assert_select "input#virtual_server_type_provided_id", :name => "virtual_server_type[provided_id]"
      assert_select "textarea#virtual_server_type_properties_yaml", :name => "virtual_server_type[properties_yaml]"
      assert_select "input#virtual_server_type_caption", :name => "virtual_server_type[caption]"
    end
  end
end
