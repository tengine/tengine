require 'spec_helper'

describe "tengine/resource/servers/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:servers, [
      stub_model(Tengine::Resource::Server,{
        :provider => stub_model(Tengine::Resource::Provider, :name => "EC2 test account"),
        :name => "Name",
        :description => "Description",
        # :host => nil,
        :provided_name => "Provided Name",
        :status => "Status",
        :public_hostname => "Public Hostname",
        :public_ipv4 => "Public Ipv4",
        :local_hostname => "Local Hostname",
        :local_ipv4 => "Local Ipv4",
        :properties => {"a"=>"1", "b"=>"2"},
        :provided_image_name => "Provided Image Name"
      }),
      stub_model(Tengine::Resource::Server, {
        :provider => stub_model(Tengine::Resource::Provider, :name => "EC2 test account"),
        :name => "Name",
        :description => "Description",
        # :host => nil,
        :provided_name => "Provided Name",
        :status => "Status",
        :public_hostname => "Public Hostname",
        :public_ipv4 => "Public Ipv4",
        :local_hostname => "Local Hostname",
        :local_ipv4 => "Local Ipv4",
        :properties => {"a"=>"1", "b"=>"2"},
        # :provided_image_name => "Provided Image Name"
      })
    ]))
  end

  it "renders a list of tengine_resource_servers" do
    render
    assert_select "tr>td", :text => "EC2 test account".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Provided Name".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Public Hostname".to_s, :count => 2
    assert_select "tr>td", :text => "Public Ipv4".to_s, :count => 2
    assert_select "tr>td", :text => "Local Hostname".to_s, :count => 2
    assert_select "tr>td", :text => "Local Ipv4".to_s, :count => 2
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
    # assert_select "tr>td", :text => "Provided Image Name".to_s, :count => 2
  end
end
