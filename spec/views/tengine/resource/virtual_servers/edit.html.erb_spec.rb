require 'spec_helper'

describe "tengine/resource/virtual_servers/edit.html.erb" do
  before(:each) do
    @virtual_server = assign(:virtual_server, stub_model(Tengine::Resource::VirtualServer,
      :provider => nil,
      :name => "MyString",
      :provided_name => "MyString",
      :description => "MyString",
      :status => "MyString",
      :addresses => {"a"=>"1", "b"=>"2"},
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_id => "MyString",
      :provided_type_id => "MyString",
      :host_server => ""
    ))
  end

  it "renders the edit virtual_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_virtual_servers_path(@virtual_server), :method => "post" do
      assert_select "input#virtual_server_provider_id", :name => "virtual_server[provider_id]"
      assert_select "input#virtual_server_name", :name => "virtual_server[name]"
      assert_select "input#virtual_server_provided_name", :name => "virtual_server[provided_name]"
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
