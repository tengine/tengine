require 'spec_helper'

describe "tengine/resource/physical_servers/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:physical_servers, [
      stub_model(Tengine::Resource::PhysicalServer,
        :name => "Name1",
        :provided_id => "Provided Name",
        :description => "Description",
        :status => "online",
        :properties => {"a"=>"1", "b"=>"2"}
      ),
      stub_model(Tengine::Resource::PhysicalServer,
        :provider => stub_model(Tengine::Resource::Provider, :name => "EC2 test account"),
        :name => "Name2",
        :provided_id => "Provided Name",
        :description => "Description",
        :status => "registering",
        :properties => {"a"=>"1", "b"=>"2"}
      )
    ]))
  end

  it "renders a list of tengine_resource_physical_servers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Provided Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
  end
end
