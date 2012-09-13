require 'spec_helper'

describe "tengine/resource/servers/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:servers, [
      stub_model(Tengine::Resource::Server,
        :provider => stub_model(Tengine::Resource::Provider, :name => "EC2 test account"),
        :name => "Name",
        :provided_id => "Provided Name",
        :description => "Description",
        :status => "Status",
        :addresses => {"eth0"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
        :properties => {"a"=>"1", "b"=>"2"}
      ),
      stub_model(Tengine::Resource::Server,
        :provider => stub_model(Tengine::Resource::Provider, :name => "EC2 test account"),
        :name => "Name",
        :provided_id => "Provided Name",
        :description => "Description",
        :status => "Status",
        :addresses => {"eth0"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
        :properties => {"a"=>"1", "b"=>"2"}
      )
    ]))
  end

  it "renders a list of tengine_resource_servers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "EC2 test account".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Provided Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td>pre", :text => ERB::Util.html_escape(YAML.dump({"eth0"=>"192.168.1.1", "eth1"=>"10.10.10.1"})), :count => 2
    assert_select "tr>td>pre", :text => ERB::Util.html_escape(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
  end
end
