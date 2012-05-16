# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/resource/virtual_servers/edit.html.erb" do
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

    assign(:virtual_server, @virtual_server1)
  end

  after do
    Tengine::Resource::VirtualServerImage.delete_all
    Tengine::Resource::VirtualServerType.delete_all
    Tengine::Resource::PhysicalServer.delete_all
    Tengine::Resource::VirtualServer.delete_all
    Tengine::Resource::Provider.delete_all
  end

  it "renders the edit virtual_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_virtual_servers_path(@virtual_server), :method => "post" do
      assert_select "input#virtual_server_name", :name => "virtual_server[name]"
      assert_select "textarea#virtual_server_description", :name => "virtual_server[description]"
    end

    rendered.should have_xpath("//input[@type='submit'][@class='BtnNext']")
  end

  it "renders the virtual_server info" do
    render

    rendered.should have_xpath("//td", :text =>
      "#{@virtual_server1.host_server.name}(#{@virtual_server1.host_server.description})")
    rendered.should have_xpath("//td", :text => @virtual_server1.provided_id)
    rendered.should have_xpath("//td", :text => @virtual_server1.status)
    rendered.should have_xpath("//td/pre",
      :text => @virtual_server1.addresses_yaml.sub(/^---( )?(! )?\n?/, ''))
    rendered.should have_xpath("//td/pre",
      :text => @virtual_server1.properties_yaml.sub(/^---( )?(! )?\n?/, ''))
    rendered.should have_xpath("//td", :text => @type1.caption)
    rendered.should have_xpath("//td", :text => @image1.name)
  end

  it "addressesがnilのとき何もIPアドレスに表示されないこと" do
    @virtual_server1.addresses_yaml = nil
    assign(:virtual_server, @virtual_server1)

    render

    rendered.should_not have_xpath("//td/pre",
      :text => @virtual_server1.addresses_yaml.sub(/^---( )?(! )?\n?/, ''))
  end

  it "addressesが空のとき何もIPアドレスに表示されないこと" do
    @virtual_server1.addresses_yaml = {}
    assign(:virtual_server, @virtual_server1)

    render

    rendered.should_not have_xpath("//td/pre",
      :text => @virtual_server1.addresses_yaml.sub(/^---( )?(! )?\n?/, ''))
  end

  it "propertiesがnilのとき何もプロパティに表示されないこと" do
    @virtual_server1.properties_yaml = nil
    assign(:virtual_server, @virtual_server1)

    render

    rendered.should_not have_xpath("//td/pre",
      :text => @virtual_server1.properties_yaml.sub(/^---( )?(! )?\n?/, ''))
  end

  it "propertiesが空のとき何もプロパティに表示されないこと" do
    @virtual_server1.properties_yaml = {}
    assign(:virtual_server, @virtual_server1)

    render

    rendered.should_not have_xpath("//td/pre",
      :text => @virtual_server1.properties_yaml.sub(/^---( )?(! )?\n?/, ''))
  end
end
