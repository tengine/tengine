# -*- coding: utf-8 -*-
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
      :status => "online",
      :addresses => {"eth0"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
    )
    @physical_server2 = Tengine::Resource::PhysicalServer.create!(
      :provider_id => @provider.id,
      :name => "pserver2",
      :provided_id => "server1",
      :description => "Description",
      :status => "online",
      :addresses => {"eth0"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
    )
    @virtual_server1 = Tengine::Resource::VirtualServer.create!(
      :provider_id => @provider.id,
      :name => "vserver1",
      :provided_id => "i0002",
      :description => "v2Description",
      :status => "running",
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
      :status => "starting",
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
    assert_select "tr>td", :text => "starting".to_s, :count => 1
    assert_select "tr>td", :text => "running".to_s, :count => 1
    assert_select "tr>td>a", :text => "ami1".to_s, :count => 1
    assert_select "tr>td>a", :text => "ami2".to_s, :count => 1
    assert_select "tr>td", :text => "Small".to_s, :count => 1
    assert_select "tr>td", :text => "Large".to_s, :count => 1
  end

  it "renders search form" do
    render

    rendered.should have_xpath("//input[@type='text'][@id='finder_physical_server_name']")
    rendered.should have_xpath("//input[@type='text'][@id='finder_virtual_server_name']")
    rendered.should have_xpath("//input[@type='text'][@id='finder_provided_id']")
    rendered.should have_xpath("//input[@type='text'][@id='finder_description']")
    rendered.should have_xpath("//input[@type='text'][@id='finder_virtual_server_image_name']")
    rendered.should have_xpath("//input[@type='checkbox'][@id='finder_status_ids_starting']")
    rendered.should have_xpath("//input[@type='checkbox'][@id='finder_status_ids_running']")
    rendered.should have_xpath("//input[@type='checkbox'][@id='finder_status_ids_shuttingdown']")
    rendered.should have_xpath("//input[@type='checkbox'][@id='finder_status_ids_terminated']")
  end

  it "renders refresh form" do
    render

    rendered.should have_xpath("//input[@type='number'][@id='refresher_refresh_interval']")
  end

  it "renders stop form" do
    render

    rendered.should have_xpath("//input[@type='checkbox'][@id='StopAll']")
    rendered.should have_xpath("//input[@type='checkbox'][@class='StopCheckBox'][@value='#{@virtual_server1.id.to_s}']")
    rendered.should have_xpath("//input[@type='checkbox'][@class='StopCheckBox'][@value='#{@virtual_server2.id.to_s}']")
  end

  it "IDがSubmitStopAllのsubmitボタンがあること" do
    render(:file => "tengine/resource/virtual_servers/index")

    rendered.should have_xpath("//input[@type='submit'][@id='SubmitStopAll'][@disabled]", :count => 1)
  end

  it "@refresh_intervalの値が絞り込みのフォームのhiddenフィールドとしてあること" do
    assign(:refresh_interval, 10)

    render

    rendered.should have_xpath("//input[@type='hidden'][@id='refresher_refresh_interval'][@value='10']")
  end

  it "@finderの値が画面の更新間隔のフォームのhiddenフィールドとしてあること" do
    finder = Tengine::Resource::VirtualServer::Finder.new
    finder.physical_server_name = "test"
    finder.provided_id = "server"
    finder.description = "testdesc"
    finder.virtual_server_name = "vserver"
    finder.virtual_server_image_name = "vimage"
    finder.stub(:status_ids).and_return(["starting", "running"])
    assign(:finder, finder)

    render

    rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='finder_physical_server_name'][@value='test']")
    rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='finder_virtual_server_name'][@value='vserver']")
    rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='finder_provided_id'][@value='server']")
    rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='finder_description'][@value='testdesc']")
    rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='finder_virtual_server_image_name'][@value='vimage']")
    rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='finder_status_ids_'][@value='starting']")
    rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='finder_status_ids_'][@value='running']")
  end

  it "@refresh_intervalの値が仮想サーバ停止のフォームにhiddenフィールドとしてあること" do
    assign(:refresh_interval, 10)

    render

    rendered.should have_xpath("//form[@method='post']/input[@type='hidden'][@id='refresher_refresh_interval'][@value='10']")
  end

  it "@finderの値が仮想サーバ停止のフォームにhiddenフィールドとしてあること" do
    finder = Tengine::Resource::VirtualServer::Finder.new
    finder.physical_server_name = "test"
    finder.provided_id = "server"
    finder.description = "testdesc"
    finder.virtual_server_name = "vserver"
    finder.virtual_server_image_name = "vimage"
    finder.stub(:status_ids).and_return(["starting", "running"])
    assign(:finder, finder)

    render

    rendered.should have_xpath("//form[@method='post']/input[@type='hidden'][@id='finder_physical_server_name'][@value='test']")
    rendered.should have_xpath("//form[@method='post']/input[@type='hidden'][@id='finder_virtual_server_name'][@value='vserver']")
    rendered.should have_xpath("//form[@method='post']/input[@type='hidden'][@id='finder_provided_id'][@value='server']")
    rendered.should have_xpath("//form[@method='post']/input[@type='hidden'][@id='finder_description'][@value='testdesc']")
    rendered.should have_xpath("//form[@method='post']/input[@type='hidden'][@id='finder_virtual_server_image_name'][@value='vimage']")
    rendered.should have_xpath("//form[@method='post']/input[@type='hidden'][@id='finder_status_ids_'][@value='starting']")
    rendered.should have_xpath("//form[@method='post']/input[@type='hidden'][@id='finder_status_ids_'][@value='running']")
  end

  it "仮想サーバ名で絞り込みを行ったとき絞り込んだ仮想サーバが表示されていること" do
    finder = Tengine::Resource::VirtualServer::Finder.new
    finder.virtual_server_name = "vserver1"
    finder.stub(:status_ids).and_return([])
    assign(:finder, finder)

    render

    rendered.should have_xpath("//td", :text => "vserver1")
    rendered.should_not have_xpath("//td", :text => "vserver2")
  end

  it "プロバイダによるIDで絞り込みを行ったとき絞り込んだ仮想サーバが表示されていること" do
    finder = Tengine::Resource::VirtualServer::Finder.new
    finder.provided_id = "i0002"
    finder.stub(:status_ids).and_return([])
    assign(:finder, finder)

    render

    rendered.should have_xpath("//td", :text => "vserver1")
    rendered.should_not have_xpath("//td", :text => "vserver2")
  end

  it "説明で絞り込みを行ったとき絞り込んだ仮想サーバが表示されていること" do
    finder = Tengine::Resource::VirtualServer::Finder.new
    finder.description = "v2Description"
    finder.stub(:status_ids).and_return([])
    assign(:finder, finder)

    render

    rendered.should have_xpath("//td", :text => "v2Description")
    rendered.should_not have_xpath("//td", :text => "v3Description")
  end

  it "仮想サーバイメージ名で絞り込みを行ったとき絞り込んだ仮想サーバが表示されていること" do
    finder = Tengine::Resource::VirtualServer::Finder.new
    finder.virtual_server_image_name = "vimage1"
    finder.stub(:status_ids).and_return([])
    assign(:finder, finder)

    render

    rendered.should have_xpath("//td", :text => "vserver1")
    rendered.should_not have_xpath("//td", :text => "vserver2")
  end

  it "ステータスで絞り込みを行ったとき絞り込んだ仮想サーバが表示されていること" do
    finder = Tengine::Resource::VirtualServer::Finder.new
    finder.status_ids = ["starting"]
    assign(:finder, finder)

    render

    rendered.should have_xpath("//td", :text => "vserver2")
    rendered.should_not have_xpath("//td", :text => "vserver1")
  end
end
