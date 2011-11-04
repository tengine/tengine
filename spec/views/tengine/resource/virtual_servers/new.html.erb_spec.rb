require 'spec_helper'

describe "tengine/resource/virtual_servers/new.html.erb" do
  before(:each) do
    assign(:virtual_server, stub_model(Tengine::Resource::VirtualServer,
      :provider => nil,
      :name => "MyString",
      :provided_id => "MyString",
      :description => "MyString",
      :status => "MyString",
      :addresses => {"a"=>"1", "b"=>"2"},
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_id => "MyString",
      :provided_type_id => "MyString",
      :host_server => ""
    ).as_new_record)
  end

  it "renders new virtual_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_virtual_servers_path, :method => "post" do
      assert_select "input#virtual_server_provider_id", :name => "virtual_server[provider_id]"
      assert_select "input#virtual_server_name", :name => "virtual_server[name]"
      assert_select "input#virtual_server_provided_id", :name => "virtual_server[provided_id]"
      assert_select "input#virtual_server_description", :name => "virtual_server[description]"
      assert_select "input#virtual_server_status", :name => "virtual_server[status]"
      assert_select "textarea#virtual_server_addresses_yaml", :name => "virtual_server[addresses_yaml]"
      assert_select "textarea#virtual_server_properties_yaml", :name => "virtual_server[properties_yaml]"
      assert_select "input#virtual_server_provided_image_id", :name => "virtual_server[provided_image_id]"
      assert_select "input#virtual_server_provided_type_id", :name => "virtual_server[provided_type_id]"
      assert_select "input#virtual_server_host_server", :name => "virtual_server[host_server]"
    end
  end
end
