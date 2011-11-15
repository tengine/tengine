require 'spec_helper'

describe "tengine/resource/physical_servers/edit.html.erb" do
  before(:each) do
    @physical_server = assign(:physical_server, stub_model(Tengine::Resource::PhysicalServer,
      :name => "MyString",
      :provided_id => "MyString",
      :description => "MyString",
      :status => "MyString",
      :properties => {"a"=>"1", "b"=>"2"}
    ))
  end

  it "renders the edit physical_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_physical_servers_path(@physical_server), :method => "post" do
      assert_select "input#physical_server_name", :name => "physical_server[name]"
      rendered.should match(/Provided Name/)
      rendered.should match(/Description/)
      rendered.should match(/Status/)
      assert_select "textarea#physical_server_properties_yaml", :name => "physical_server[properties_yaml]"
    end
  end
end
