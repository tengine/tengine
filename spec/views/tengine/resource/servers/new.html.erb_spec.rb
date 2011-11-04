require 'spec_helper'

describe "tengine/resource/servers/new.html.erb" do
  before(:each) do
    assign(:server, stub_model(Tengine::Resource::Server,
      :provider => stub_model(Tengine::Resource::Provider, :name => "EC2 test account"),
      :name => "MyString",
      :provided_name => "MyString",
      :description => "MyString",
      :status => "MyString",
      :addresses => {"a"=>"1", "b"=>"2"},
      :properties => {"a"=>"1", "b"=>"2"}
    ).as_new_record)
  end

  it "renders new server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_servers_path, :method => "post" do
      assert_select "div.field", :text => /Provider:\n\s*EC2 test account/
      assert_select "input#server_name", :name => "server[name]"
      assert_select "input#server_provided_name", :name => "server[provided_name]"
      assert_select "input#server_description", :name => "server[description]"
      assert_select "input#server_status", :name => "server[status]"
      assert_select "textarea#server_addresses_yaml", :name => "server[addresses_yaml]"
      assert_select "textarea#server_properties_yaml", :name => "server[properties_yaml]"
    end
  end
end
