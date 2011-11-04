require 'spec_helper'

describe "tengine/resource/physical_servers/new.html.erb" do
  before(:each) do
    assign(:physical_server, stub_model(Tengine::Resource::PhysicalServer,
      :provider => nil,
      :name => "MyString",
      :provided_name => "MyString",
      :description => "MyString",
      :status => "MyString",
      :addresses => {"a"=>"1", "b"=>"2"},
      :properties => {"a"=>"1", "b"=>"2"}
    ).as_new_record)
  end

  it "renders new physical_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_physical_servers_path, :method => "post" do
      assert_select "input#physical_server_provider_id", :name => "physical_server[provider_id]"
      assert_select "input#physical_server_name", :name => "physical_server[name]"
      assert_select "input#physical_server_provided_name", :name => "physical_server[provided_name]"
      assert_select "input#physical_server_description", :name => "physical_server[description]"
      assert_select "input#physical_server_status", :name => "physical_server[status]"
      assert_select "textarea#physical_server_addresses_yaml", :name => "physical_server[addresses_yaml]"
      assert_select "textarea#physical_server_properties_yaml", :name => "physical_server[properties_yaml]"
    end
  end
end
