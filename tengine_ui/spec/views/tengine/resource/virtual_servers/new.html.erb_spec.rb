require 'spec_helper'

describe "tengine/resource/virtual_servers/new.html.erb" do
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
      :provided_id => "large",
      :caption => "Large",
    )
    @type2 = Tengine::Resource::VirtualServerType.create!(
      :provider_id => @provider.id,
      :provided_id => "small",
      :caption => "Small",
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
    @virtual_server1 = Tengine::Resource::VirtualServer.create!(
      :provider_id => @provider.id,
      :name => "vserver1",
      :provided_id => "i0002",
      :description => "v2Description",
      :status => "Status",
      :addresses => {"ip_address"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_id => "ami1",
      :provided_type_id => "large",
      :host_server_id => @physical_server1.id,
    )

    assign(:virtual_server, Tengine::Resource::VirtualServer.new)
    assign(:physical_servers_for_select, [@physical_server1])
    assign(:virtual_server_images_for_select, [@image1, @image2])
    assign(:virtual_server_types_for_select, [@type1, @type2])
    assign(:starting_number, 0)
    assign(:starting_number_max, 10)
    assign(:provider, @provider)
  end

  after do
    Tengine::Resource::VirtualServerImage.delete_all
    Tengine::Resource::VirtualServerType.delete_all
    Tengine::Resource::PhysicalServer.delete_all
    Tengine::Resource::VirtualServer.delete_all
    Tengine::Resource::Provider.delete_all
  end

  it "renders new virtual_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_virtual_servers_path, :method => "post" do
      assert_select "input#virtual_server_name", :name => "virtual_server[name]"
      assert_select "textarea#virtual_server_description", :name => "virtual_server[description]"
      assert_select "select#virtual_server_provided_image_id", :name => "virtual_server[provided_image_id]"
      assert_select "select#virtual_server_provided_type_id", :name => "virtual_server[provided_type_id]"
      assert_select "select#virtual_server_host_server_id", :name => "virtual_server[host_server_id]"
      assert_select "input#virtual_server_starting_number", :name => "virtual_server[starting_number]", :max => @starting_number_max, :value => @starting_number
      assert_select "input#starting_number_max", :name => "starting_number_max", :value => @starting_number_max
      rendered.should have_xpath("//input[@type='hidden'][@id='virtual_server_provider_id'][@value='#{@provider.id}']")
    end
  end

  it "not renders virtual_server_provider_id field" do
    assign(:provider, nil)
    render

    rendered.should_not have_xpath("//input[@type='hidden'][@id='virtual_server_provider_id']")
  end
end
