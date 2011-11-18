require 'spec_helper'

describe "tengine/resource/virtual_servers/index.html.erb" do
  before(:each) do
    Tengine::Resource::VirtualServerImage.delete_all
    Tengine::Resource::VirtualServerType.delete_all
    Tengine::Resource::PhysicalServer.delete_all
    Tengine::Resource::VirtualServer.delete_all
    Tengine::Resource::Provider.delete_all
    @provider = Tengine::Resource::Provider.create!(
      :name => "provider1",
      :description => "Description",
    )
    @image1 = Tengine::Resource::VirtualServerImage.create!(
      :provider_id => @provider.id,
      :name => "vimage1",
      :description => "Description",
      :provided_id => "ami1",
    )
    @image2 = Tengine::Resource::VirtualServerImage.create!(
      :provider_id => @provider.id,
      :name => "vimage2",
      :description => "Description",
      :provided_id => "ami2",
    )
    @type1 = Tengine::Resource::VirtualServerType.create!(
      :provider_id => @provider.id,
      :provided_id => "Large",
      :caption => "LargeCaption",
    )
    @type2 = Tengine::Resource::VirtualServerType.create!(
      :provider_id => @provider.id,
      :provided_id => "Small",
      :caption => "SmallCaption",
    )
    @physical_server1 = Tengine::Resource::PhysicalServer.create!(
      :provider_id => @provider.id,
      :name => "pserver1",
      :provided_id => "server1",
      :description => "Description",
      :status => "Status",
      :addresses => {"eth0"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
    )
    @physical_server2 = Tengine::Resource::PhysicalServer.create!(
      :provider_id => @provider.id,
      :name => "pserver2",
      :provided_id => "server1",
      :description => "Description",
      :status => "Status",
      :addresses => {"eth0"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
    )
    @virtual_server1 = Tengine::Resource::VirtualServer.create!(
      :provider_id => @provider.id,
      :name => "vserver1",
      :provided_id => "i0002",
      :description => "v2Description",
      :status => "Status",
      :addresses => {"eth0"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_id => "ami1",
      :provided_type_id => "Large",
      :host_server_id => @physical_server1.id,
    )
    @virtual_server2 = Tengine::Resource::VirtualServer.create!(
      :provider_id => @provider.id,
      :name => "vserver2",
      :provided_id => "i0003",
      :description => "v3Description",
      :status => "Status",
      :addresses => {"eth0"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_id => "ami2",
      :provided_type_id => "Small",
      :host_server_id => @physical_server1.id,
    )

    assign(:physical_servers, [@physical_server1, @physical_server2])
    finder = Tengine::Resource::VirtualServer::Finder.new
    finder.stub(:status_ids).and_return([])
    assign(:finder, finder)
    assign(:auto_refresh, false)
  end

  after do
    Tengine::Resource::VirtualServerImage.delete_all
    Tengine::Resource::VirtualServerType.delete_all
    Tengine::Resource::PhysicalServer.delete_all
    Tengine::Resource::VirtualServer.delete_all
    Tengine::Resource::Provider.delete_all
  end

  it "renders a list of tengine_resource_virtual_servers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td>a", :text => "pserver1".to_s, :count => 1
    assert_select "tr>td>a", :text => "pserver2".to_s, :count => 1
    assert_select "tr>td", :text => "i0002".to_s, :count => 1
    assert_select "tr>td", :text => "i0003".to_s, :count => 1
    assert_select "tr>td>div>span", :text => "v2Description".to_s, :count => 1
    assert_select "tr>td>div>span", :text => "v3Description".to_s, :count => 1
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td>a", :text => "ami1".to_s, :count => 1
    assert_select "tr>td>a", :text => "ami2".to_s, :count => 1
    assert_select "tr>td", :text => "Small".to_s, :count => 1
    assert_select "tr>td", :text => "Large".to_s, :count => 1
  end
end
