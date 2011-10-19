require 'spec_helper'

describe "tengine/resource/servers/new.html.erb" do
  before(:each) do
    assign(:server, stub_model(Tengine::Resource::Server,{
      :provider => stub_model(Tengine::Resource::Provider, :name => "EC2 test account"),
      :name => "MyString",
      :description => "MyString",
      # :host => nil,
      :provided_name => "MyString",
      :status => "MyString",
      :public_hostname => "MyString",
      :public_ipv4 => "MyString",
      :local_hostname => "MyString",
      :local_ipv4 => "MyString",
      :properties => {"a"=>"1", "b"=>"2"},
      # :provided_image_name => "MyString"
    }).as_new_record)
  end

  it "renders new server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_servers_path, :method => "post" do
      assert_select "div.field", :text => /Provider:\n\s*EC2 test account/
      assert_select "input#server_name", :name => "server[name]"
      assert_select "input#server_description", :name => "server[description]"
      # assert_select "input#server_host_id", :name => "server[host_id]"
      assert_select "input#server_provided_name", :name => "server[provided_name]"
      assert_select "input#server_status", :name => "server[status]"
      assert_select "input#server_public_hostname", :name => "server[public_hostname]"
      assert_select "input#server_public_ipv4", :name => "server[public_ipv4]"
      assert_select "input#server_local_hostname", :name => "server[local_hostname]"
      assert_select "input#server_local_ipv4", :name => "server[local_ipv4]"
      assert_select "textarea#server_properties_yaml", :name => "server[properties_yaml]"
      # assert_select "input#server_provided_image_name", :name => "server[provided_image_name]"
    end
  end
end
