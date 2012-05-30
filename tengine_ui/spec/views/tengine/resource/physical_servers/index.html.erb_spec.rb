# -*- coding: utf-8 -*-

require 'spec_helper'
require 'ostruct'

describe "tengine/resource/physical_servers/index.html.erb" do
  context "要素数がページネーションの1ページ以内のとき" do
    before(:each) do
      Tengine::Resource::PhysicalServer.delete_all
      @ps1 = stub_model(Tengine::Resource::PhysicalServer,
        :id => BSON::ObjectId("4e855633c3406b3a9f000001"),
        :name => "physical1",
        :description  => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        :status => "offline",
        :properties => {"a"=>"b","c"=>"d"},
        :cpu_cores =>"4",
        :memory_size => "4096",
        :provided_id => "abcde"
      )
      @ps2 = stub_model(Tengine::Resource::PhysicalServer,
        :id => BSON::ObjectId("4ec7e021df46900a35000003"),
        :name => "physical2",
        :description  => "aaaaaaaaaaaaaaaaaaaaaaaaaaab",
        :status => "offline",
        :properties => {"a"=>"b","c"=>"d"},
        :cpu_cores => "6",
        :memory_size => "3096",
        :provided_id => "abcde"
      )
      @ps3 = stub_model(Tengine::Resource::PhysicalServer,
        :id => BSON::ObjectId("4ec7e049df46900a35000005"),
        :name => "physical3",
        :description  => "aaaaaaaaaaaaaaaaaaaaaaaaaaac",
        :status => "online",
        :properties => {"a"=>"b","c"=>"d"},
        :cpu_cores=>"8",
        :memory_size =>"2096",
        :provided_id => "abcde"
      )

      assign(:physical_servers,
        Kaminari.paginate_array([@ps1, @ps2, @ps3]).page(1).per(3))
      @check_status = {
        "status_01" => ["unchecked", :online],
        "status_02" => ["unchecked", :offline]
      }
      @request.params[:controller] = "tengine/resource/physical_servers"
      @request.params[:action] = "index"
    end

    it "renders a list of tengine_resource_physical_servers" do
      render

      # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select "tr>td", :text => "physical1".to_s, :count => 1
      assert_select "tr>td", :text => "abcde".to_s, :count => 3
      assert_select "tr>td", :text => /aaaaaaaaaaaaaaaaa.../, :count => 3
      assert_select "tr>td", :text => "6".to_s, :count => 1
      assert_select "tr>td", :text =>"4096".to_s, :count=> 1
      assert_select "tr>td", :text => "offline".to_s, :count => 2
      properties = YAML.dump({"a"=>"b", "c"=>"d"}).sub(/^---( )?(! )?\n?/, '')
      rendered.should have_xpath("//div[@id='yamlProperties']/div/pre",
        :text => properties)
      rendered.should have_xpath("//div[@id='yamlDescription']")
    end

    it "descriptionがnilのときYamlViewが表示されていないこと" do
      @ps1.description = nil
      @ps2.description = nil
      @ps3.description = nil
      render

      rendered.should_not have_xpath("//div[@class='YamlView'][@id='yamlDescription']")
    end

    it "descriptionが空のときYamlViewが表示されていないこと" do
      @ps1.description = ""
      @ps2.description = ""
      @ps3.description = ""
      render

      rendered.should_not have_xpath("//div[@class='YamlView'][@id='yamlDescription']")
    end

    it "propertiesがnilのときYamlViewが表示されていないこと" do
      @ps1.properties = nil
      @ps2.properties = nil
      @ps3.properties = nil
      render

      rendered.should_not have_xpath("//div[@class='YamlView'][@id='yamlProperties']")
    end

    it "propertiesが空のときYamlViewが表示されていないこと" do
      @ps1.properties = ""
      @ps2.properties = ""
      @ps3.properties = ""
      render

      rendered.should_not have_xpath("//div[@class='YamlView'][@id='yamlProperties']")
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

    it "検索フォームに値が入っていないこと、セレクトボックスがすべてチェックされていないこと" do
      render

      assert_select "input[id='finder_name']", :text => "", :count => 1
      assert_select "input[id='finder_provided_id']", :text => "", :count => 1
      assert_select "input[id='finder_description']", :text => "", :count => 1
      assert_select "input[name='finder[status_01]'][value = 0]"
      assert_select "input[name='finder[status_02]'][value = 0]"

      rendered.should have_xpath("//label[@for='finder_status_01']")
      rendered.should have_xpath("//label[@for='finder_status_02']")
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
  end

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
          :status => "offline",
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
        stub_model(Tengine::Resource::PhysicalServer,
          :id => BSON::ObjectId("4e855633c3406b3a9f000032"),
          :name => "physical5",
          :provided_id=>"aaaaaa5",
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
      @check_status = {
        "status_01" => ["unchecked", :online],
        "status_02" => ["unchecked", :offline]
      }
    end

    it "ページネーションが表示されていること" do
      render

      rendered.should have_xpath("//div[@class='PageStats']", count:2)
    end

    it "件数が表示されていること" do
      render

      rendered.should have_content("全3件中3〜3件を表示")
    end

    context "nameで検索していたとき" do
      before do
        @request.query_parameters[:finder] = { :name => "physical" }
        @request.params[:finder] = { :name => "physical" }
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
            query_param.merge(:sort => {:description => :asc}))
        )
      end
    end
  end
end
