# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/resource/physical_servers/edit.html.erb" do
  before(:each) do
    @physical_server = assign(:physical_server, stub_model(Tengine::Resource::PhysicalServer,
      :name => "PhysicalServer Name",
      :provided_id => "provided_id",
      :cpu_cores => "2",
      :memory_size => "2048",
      :status => "online",
      :properties => {"a"=>"1", "b"=>"2"},
      :description => "MyString",
    ))
  end

  it "renders the edit physical_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_physical_servers_path(@physical_server), :method => "post" do
      rendered.should match(/PhysicalServer Name/)
      rendered.should match(/provided_id/)
      rendered.should match(/2/)
      rendered.should match(/2048/)
      rendered.should match(/online/)
      rendered.should match(/---\na: '1'\nb: '2'\n/)
      rendered.should have_xpath("//td/pre", :text => @physical_server.properties_yaml)
      assert_select "textarea#physical_server_description", :name => "physical_server[description]"
    end
  end

  it "更新ボタンが表示されていること" do
    render

    rendered.should have_button(I18n.t("views.links.update"))
  end

  it "キャンセルボタンが表示されていること" do
    render

    rendered.should have_button(I18n.t("cancel"))
  end

  it "propertiesがnilのときプロパティに何も表示されないこと" do
    @physical_server.properties = nil
    render

    rendered.should_not have_xpath("//td/pre")
  end

  it "propertiesが空のときプロパティに何も表示されないこと" do
    @physical_server.properties = {}
    render

    rendered.should_not have_xpath("//td/pre")
  end
end
