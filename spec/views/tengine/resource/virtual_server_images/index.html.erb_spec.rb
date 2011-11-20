# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/resource/virtual_server_images/index.html.erb" do
  before(:each) do
    assign(:virtual_server_images, Kaminari.paginate_array([
      stub_model(Tengine::Resource::VirtualServerImage,
        :name => "Name",
        :provided_id => "Provided Name",
        :provided_description => "Provided Description",
        :description => "Description"
      ),
      stub_model(Tengine::Resource::VirtualServerImage,
        :name => "Name",
        :provided_id => "Provided Name",
        :provided_description => "Provided Description",
        :description => "Description"
      )
    ]).page(1).per(5))

    @request.params[:controller] = "tengine/resource/virtual_server_images"
    @request.params[:action] = "index"
  end

  it "renders a list of tengine_resource_virtual_server_images" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Provided Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Provided Description".to_s, :count => 2
    assert_select "tr>td", :text => /Description/, :count => 2
  end

  it "nameのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_resource_virtual_server_images_path(:sort=>{:name=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::VirtualServerImage.human_attribute_name(:name))
  end

  it "descriptionのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_resource_virtual_server_images_path(:sort=>{:description=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::VirtualServerImage.human_attribute_name(:description))
  end

  it "検索フォームに値が入っていないこと" do
    render

    assert_select "input[id='finder_name']", :text => "", :count => 1
    assert_select "input[id='finder_provided_id']", :text => "", :count => 1
   # assert_select "input[id='finder_provided_description']", :text => "", :count => 1
    
  end


  it "検索ボタンが表示されていること" do
    render

    rendered.should have_button(I18n.t("views.links.search"))
  end

  it "リセットボタンが表示されていること" do
    render

    rendered.should have_xpath(%|//input[@type='reset'][@value='#{I18n.t("views.links.reset")}']|, :count => 1)
  end

  it "ソートのリンクが表示されていること" do
    render

    href = tengine_resource_virtual_server_images_path(:sort=>{:name=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::VirtualServerImage.human_attribute_name(:name))
    href = tengine_resource_virtual_server_images_path(:sort=>{:description=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::VirtualServerImage.human_attribute_name(:description))
    href = tengine_resource_virtual_server_images_path(:sort=>{:provided_id=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::VirtualServerImage.human_attribute_name(:provided_id))
    href = tengine_resource_virtual_server_images_path(:sort=>{:provided_description=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::VirtualServerImage.human_attribute_name(:provided_description))
  end

end
