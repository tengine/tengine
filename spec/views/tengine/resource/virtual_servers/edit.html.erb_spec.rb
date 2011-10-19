require 'spec_helper'

describe "tengine/resource/virtual_servers/edit.html.erb" do
  before(:each) do
    @virtual_server = assign(:virtual_server, stub_model(Tengine::Resource::VirtualServer,
      :name => "MyString",
      :description => "MyString",
      :host => nil,
      :provided_name => "MyString",
      :status => "MyString",
      :public_hostname => "MyString",
      :public_ipv4 => "MyString",
      :local_hostname => "MyString",
      :local_ipv4 => "MyString",
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_name => "MyString"
    ))
  end

  it "renders the edit virtual_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_virtual_servers_path(@virtual_server), :method => "post" do
      assert_select "input#virtual_server_name", :name => "virtual_server[name]"
      assert_select "input#virtual_server_description", :name => "virtual_server[description]"
      assert_select "input#virtual_server_host_id", :name => "virtual_server[host_id]"
      assert_select "input#virtual_server_provided_name", :name => "virtual_server[provided_name]"
      assert_select "input#virtual_server_status", :name => "virtual_server[status]"
      assert_select "input#virtual_server_public_hostname", :name => "virtual_server[public_hostname]"
      assert_select "input#virtual_server_public_ipv4", :name => "virtual_server[public_ipv4]"
      assert_select "input#virtual_server_local_hostname", :name => "virtual_server[local_hostname]"
      assert_select "input#virtual_server_local_ipv4", :name => "virtual_server[local_ipv4]"
      assert_select "textarea#virtual_server_properties_yaml", :name => "virtual_server[properties_yaml]"
      assert_select "input#virtual_server_provided_image_name", :name => "virtual_server[provided_image_name]"
    end
  end
end
