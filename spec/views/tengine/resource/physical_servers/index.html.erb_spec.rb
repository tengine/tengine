# -*- coding: utf-8 -*-

require 'spec_helper'
require 'ostruct'

describe "tengine/resource/physical_servers/index.html.erb" do
  before(:each) do
    Tengine::Resource::PhysicalServer.delete_all
    temp = [
      stub_model(Tengine::Resource::PhysicalServer,
        :id => BSON::ObjectId("4e855633c3406b3a9f000001"),
        :name => "physical1",
        :description  => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        :status => "registering",
        :properties => {"a"=>"b","c"=>"d"},
        :cpu_cores =>"4",
        :memory_size => "4096",
        :provided_id => "abcde"
      ),
      stub_model(Tengine::Resource::PhysicalServer,
        :id => BSON::ObjectId("4ec7e021df46900a35000003"),
        :name => "physical2",
        :description  => "aaaaaaaaaaaaaaaaaaaaaaaaaaab",
        :status => "registering",
        :properties => {"a"=>"b","c"=>"d"},
        :cpu_cores => "6",
        :memory_size => "3096",
        :provided_id => "abcde"
      ),
      stub_model(Tengine::Resource::PhysicalServer,
        :id => BSON::ObjectId("4ec7e049df46900a35000005"),
        :name => "physical3",
        :description  => "aaaaaaaaaaaaaaaaaaaaaaaaaaac",
        :status => "online",
        :properties => {"a"=>"b","c"=>"d"},
        :cpu_cores=>"8",
        :memory_size =>"2096",
        :provided_id => "abcde"
      )
    ]


    assign(:physical_servers, Kaminari.paginate_array(temp).page(1).per(3))
    @check_status = {"status_01" => "checked", "status_02" => "checked"}
    @request.params[:controller] = "tengine/resource/physical_servers"
    @request.params[:action] = "index"
  end


  it "renders a list of tengine_resource_physical_servers" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "physical1".to_s, :count => 1
    assert_select "tr>td", :text => "abcde".to_s, :count => 3
    assert_select "tr>td", :text => /aaaaaaaaaaaaaaaaaaaa.../, :count => 3
    assert_select "tr>td", :text => "6".to_s, :count => 1
    assert_select "tr>td", :text =>"4096".to_s, :count=> 1
    assert_select "tr>td", :text => "registering".to_s, :count => 2
    assert_select "tr>td", :text => /#{CGI.escapeHTML(YAML.dump({"a"=>"b", "c"=>"d"}))}/, :count => 3
  end

  it "nameのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_resource_physical_servers_path(:sort=>{:name=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::PhysicalServer.human_attribute_name(:name))
  end

  it "descriptionのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_resource_physical_servers_path(:sort=>{:description=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::PhysicalServer.human_attribute_name(:description))
  end

  it "検索フォームに値が入っていないこと、セレクトボックスがすべてチェックされていること" do
    render

    assert_select "input[id='finder_name']", :text => "", :count => 1
    assert_select "input[id='finder_provided_id']", :text => "", :count => 1
    assert_select "input[id='finder_description']", :text => "", :count => 1
    assert_select "input[id='finder_status_01'][type = checkbox][value = 1]"
    assert_select "input[id='finder_status_02'][type = checkbox][value = 1]"
    
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

    href = tengine_resource_physical_servers_path(:sort=>{:name=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::PhysicalServer.human_attribute_name(:name))
    href = tengine_resource_physical_servers_path(:sort=>{:description=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::PhysicalServer.human_attribute_name(:description))
    href = tengine_resource_physical_servers_path(:sort=>{:provided_id=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::PhysicalServer.human_attribute_name(:provided_id))
    href = tengine_resource_physical_servers_path(:sort=>{:cpu_cores=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::PhysicalServer.human_attribute_name(:cpu_cores))
    href = tengine_resource_physical_servers_path(:sort=>{:memory_size=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::PhysicalServer.human_attribute_name(:memory_size))
    href = tengine_resource_physical_servers_path(:sort=>{:status=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::PhysicalServer.human_attribute_name(:status))
  end

=begin
  context "ページの2ページ目を表示したとき" do
    before(:each) do
      assign(:physical_servers, Kaminari.paginate_array([
        stub_model(Tengine::Resource::PhysicalServer,
          :id => BSON::ObjectId("4e855633c3406b3a9f000011"),
          :name => "physical3",
          :provided_id=>"aaaaaa3",
          :description => "sasisuseso",
          :cpu_core => "2",
          :memory_size => "4096",
          :status => "registering",
          :properties => {:aa => "bb", :cc=> "dd"},
        ),
        stub_model(Tengine::Resource::PhysicalServer,
          :id => BSON::ObjectId("4e855633c3406b3a9f000022"),
          :name => "physical4",
          :provided_id=>"aaaaaa3",
          :description => "aiueo",
          :cpu_core => "2",
          :memory_size => "4096",
          :status => "online",
          :properties => {:aa => "bb", :cc=> "dd"},
        ),
      ]).page(2).per(2))
      @request.query_parameters[:page] = 2
      @request.params[:controller] = "tengine/resource/physical_servers"
      @request.params[:action] = "index"
      @request.params[:page] = 2
    end

    it "件数が表示されていること" do
      render

      rendered.should have_content("全2件中2〜2件を表示")
    end

    context "nameで検索していたとき" do
      before do
        @request.query_parameters[:finder] = { :name => "physical" }
      end

      it "ソートのリンクに検索のクエリーパラメータのみ付加されていること" do
        render

        query_param = {:finder => @request.query_parameters[:finder]}
        rendered.should have_link(
          Tengine::Resource::PhysicalServer.human_attribute_name(:provided_id),
          :href=>tengine_resource_physical_servers_path(
            query_param.merge(:sort => {:provided_id => :asc}))
        )
        rendered.should have_link(
          Tengine::Resource::PhysicalServer.human_attribute_name(:name),
          :href=>tengine_resource_physical_servers_path(
            query_param.merge(:sort => {:name => :asc}))
        )
        rendered.should have_link(
          Tengine::Resource::PhysicalServer.human_attribute_name(:description),
          :href=>tengine_resource_physical_servers_path(
            query_param.merge(:sort => {:desc => :asc}))
        )
      end
    end
  end
=end
end
