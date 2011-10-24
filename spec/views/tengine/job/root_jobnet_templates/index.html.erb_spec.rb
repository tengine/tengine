# -*- coding: utf-8 -*-
require 'spec_helper'
require 'ostruct'

describe "tengine/job/root_jobnet_templates/index.html.erb" do
  before(:each) do
    Tengine::Job::Category.delete_all
    Tengine::Job::RootJobnetTemplate.delete_all
    category = stub_model(Tengine::Job::Category, :to_s => "category")
    templates = [
      stub_model(Tengine::Job::RootJobnetTemplate,
        :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
        :name => "Name",
        :server_name => "Server Name",
        :credential_name => "Credential Name",
        :killing_signals => ["abc", "123"],
        :killing_signal_interval => 1,
        :description => "Description",
        :script => "Script",
        :jobnet_type_cd => 2,
        :category => category,
        :lock_version => 3,
        :dsl_filepath => "Dsl Filepath",
        :dsl_lineno => 4,
        :dsl_version => "Dsl Version"
      ),
      stub_model(Tengine::Job::RootJobnetTemplate,
        :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
        :name => "Name",
        :server_name => "Server Name",
        :credential_name => "Credential Name",
        :killing_signals => ["abc", "123"],
        :killing_signal_interval => 1,
        :description => "Description",
        :script => "Script",
        :jobnet_type_cd => 2,
        :category => category,
        :lock_version => 3,
        :dsl_filepath => "Dsl Filepath",
        :dsl_lineno => 4,
        :dsl_version => "Dsl Version"
      )
    ]
    assign(:root_jobnet_templates, Kaminari.paginate_array(templates).page(1).per(5))

    children = []
    @foo = stub_model(Tengine::Job::Category,
      :id => BSON::ObjectId("4e855633c3406b3a9f000001"),
      :dsl_verion => 0,
      :name => "foo",
      :caption => "ふー",
      :parent_id => nil,
      :children => children
    )
    @baz = stub_model(Tengine::Job::Category,
      :id => BSON::ObjectId("4e855633c3406b3a9f000002"),
      :dsl_verion => 0,
      :name => "baz",
      :caption => "ばず",
      :parent => @foo,
      :children => [],
    )
    children << @baz
    assign(:root_categories, [@foo])

    @request.params[:controller] = "tengine/job/root_jobnet_templates"
    @request.params[:action] = "index"
  end

  it "renders a list of tengine_job_root_jobnet_templates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => BSON::ObjectId("4e955633c3406b3a9f000001").to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end

  it "idのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_job_root_jobnet_templates_path(:sort=>{:id=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:id))
  end

  it "nameのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_job_root_jobnet_templates_path(:sort=>{:name=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:name))
  end

  it "descriptionのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_job_root_jobnet_templates_path(:sort=>{:desc=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:description))
  end

  it "カテゴリのツリーが表示されていること" do
    render

    rendered.should have_xpath("//ul[@id='category']")
  end

  context "idの昇順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"id" => "asc"}
      @request.params[:sort] = {"id" => "asc"}
    end

    it "idのソートのリンクに降順のクエリーパラメータが付加されていてclassがascになっていること" do
      render

      href = tengine_job_root_jobnet_templates_path(:sort=>{:id=>:desc})
      rendered.should have_xpath("//a[@class='asc'][@href='#{href}']",
        :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:id))
    end

    it "nameのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
      render

      href = tengine_job_root_jobnet_templates_path(:sort=>{:name=>"asc"})
      rendered.should have_xpath("//a[@class=''][@href='#{href}']",
        :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:name))
    end

    it "カテゴリのツリーのリンクにsortパラメータがついていないこと" do
      render

      params = @request.params.select{|k, v| k.to_s != "sort"}
      rendered.should have_link(@foo.caption,
        :href=>tengine_job_root_jobnet_templates_path(
          params.merge(:category => @foo.id))
      )
    end
  end

  context "idの降順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"id" => "desc"}
    end

    it "idのソートのリンクに昇順のクエリーパラメータが付加されていてclassがdescになっていること" do
      render

      href = tengine_job_root_jobnet_templates_path(:sort=>{:id=>:asc})
      rendered.should have_xpath("//a[@class='desc'][@href='#{href}']",
        :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:id))
    end

    it "nameのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
      render

      href = tengine_job_root_jobnet_templates_path(:sort=>{:name=>"asc"})
      rendered.should have_xpath("//a[@class=''][@href='#{href}']",
        :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:name))
    end
  end

  context "nameの昇順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"name" => "asc"}
    end

    it "nameのソートのリンクに降順のクエリーパラメータが付加されていてclassがascになっていること" do
      render

      href = tengine_job_root_jobnet_templates_path(:sort=>{:name=>"desc"})
      rendered.should have_xpath("//a[@class='asc'][@href='#{href}']",
        :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:name))
    end
  end

  context "nameの降順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"name" => "desc"}
    end

    it "nameのソートのリンクに昇順のクエリーパラメータが付加されていてclassがdescになっていること" do
      render

      href = tengine_job_root_jobnet_templates_path(:sort=>{:name=>"asc"})
      rendered.should have_xpath("//a[@class='desc'][@href='#{href}']",
        :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:name))
    end
  end

  context "descriptionの昇順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"desc" => "asc"}
    end

    it "descriptionのソートのリンクに降順のクエリーパラメータが付加されていてclassがascになっていること" do
      render

      href = tengine_job_root_jobnet_templates_path(:sort=>{:desc=>"desc"})
      rendered.should have_xpath("//a[@class='asc'][@href='#{href}']",
        :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:description))
    end
  end

  context "descriptionの降順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"desc" => "desc"}
    end

    it "descriptionのソートのリンクに昇順のクエリーパラメータが付加されていてclassがdescになっていること" do
      render

      href = tengine_job_root_jobnet_templates_path(:sort=>{:desc=>"asc"})
      rendered.should have_xpath("//a[@class='desc'][@href='#{href}']",
        :text => Tengine::Job::RootJobnetTemplate.human_attribute_name(:description))
    end

  end

  it "検索フォームに値が入っていないこと" do
    render

    assert_select "input[id='finder_id']", :text => "", :count => 1
    assert_select "input[id='finder_name']", :text => "", :count => 1
    assert_select "input[id='finder_description']", :text => "", :count => 1
  end

  context "id,name,descriptionで検索したとき" do
    before do
      @finder = OpenStruct.new(
        :id =>"search id",
        :name => "search name",
        :description => "search description"
      )
    end

    it "検索フォームに検索にしようした値が入力されていること" do
      render

      assert_select "input[value='search id']", :count => 1
      assert_select "input[value='search name']", :count => 1
      assert_select "input[value='search description']", :count => 1
    end
  end

  context "nameで検索したとき" do
    before do
      @request.query_parameters[:finder] = { :name => "foo" }
      @request.params[:finder] = { :name => "foo" }
    end

    it "ソートのリンクに検索のクエリーパラメータがついていること" do
      render

      rendered.should have_link(
        Tengine::Job::RootJobnetTemplate.human_attribute_name(:id),
        :href=>tengine_job_root_jobnet_templates_path(
          @request.query_parameters.merge(:sort => {:id => :asc}))
      )
      rendered.should have_link(
        Tengine::Job::RootJobnetTemplate.human_attribute_name(:name),
        :href=>tengine_job_root_jobnet_templates_path(
          @request.query_parameters.merge(:sort => {:name => :asc}))
      )
      rendered.should have_link(
        Tengine::Job::RootJobnetTemplate.human_attribute_name(:description),
        :href=>tengine_job_root_jobnet_templates_path(
          @request.query_parameters.merge(:sort => {:desc => :asc}))
      )
    end

    it "カテゴリのツリーのリンクに検索のパラメータがついていること" do
      render

      rendered.should have_link(
        @foo.caption,
        :href=>tengine_job_root_jobnet_templates_path(@request.params.merge(:category=>@foo.id))
      )
    end
  end

  context "ページの2ページ目を表示したとき" do
    before(:each) do
      Tengine::Job::Category.delete_all
      Tengine::Job::RootJobnetTemplate.delete_all
      category = stub_model(Tengine::Job::Category, :to_s => "category")
      templates = assign(:root_jobnet_templates, Kaminari.paginate_array([
        stub_model(Tengine::Job::RootJobnetTemplate,
          :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
          :name => "Name",
          :server_name => "Server Name",
          :credential_name => "Credential Name",
          :killing_signals => ["abc", "123"],
          :killing_signal_interval => 1,
          :description => "Description",
          :script => "Script",
          :jobnet_type_cd => 2,
          :category => category,
          :lock_version => 3,
          :dsl_filepath => "Dsl Filepath",
          :dsl_lineno => 4,
          :dsl_version => "Dsl Version"
        ),
        stub_model(Tengine::Job::RootJobnetTemplate,
          :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
          :name => "Name",
          :server_name => "Server Name",
          :credential_name => "Credential Name",
          :killing_signals => ["abc", "123"],
          :killing_signal_interval => 1,
          :description => "Description",
          :script => "Script",
          :jobnet_type_cd => 2,
          :category => category,
          :lock_version => 3,
          :dsl_filepath => "Dsl Filepath",
          :dsl_lineno => 4,
          :dsl_version => "Dsl Version"
        ),
        stub_model(Tengine::Job::RootJobnetTemplate,
          :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
          :name => "Name",
          :server_name => "Server Name",
          :credential_name => "Credential Name",
          :killing_signals => ["abc", "123"],
          :killing_signal_interval => 1,
          :description => "Description",
          :script => "Script",
          :jobnet_type_cd => 2,
          :category => category,
          :lock_version => 3,
          :dsl_filepath => "Dsl Filepath",
          :dsl_lineno => 4,
          :dsl_version => "Dsl Version"
        )
      ]).page(2).per(2))

      children = []
      @foo = stub_model(Tengine::Job::Category,
        :id => BSON::ObjectId("4e855633c3406b3a9f000001"),
        :dsl_verion => 0,
        :name => "foo",
        :caption => "ふー",
        :parent_id => nil,
        :children => children
      )
      @baz = stub_model(Tengine::Job::Category,
        :id => BSON::ObjectId("4e855633c3406b3a9f000002"),
        :dsl_verion => 0,
        :name => "baz",
        :caption => "ばず",
        :parent => @foo,
        :children => [],
      )
      children << @baz
      assign(:root_categories, [@foo])

      @request.query_parameters[:page] = 2
      @request.params[:controller] = "tengine/job/root_jobnet_templates"
      @request.params[:action] = "index"
      @request.params[:page] = 2
    end

    it "件数が表示されていること" do
      render

      rendered.should have_content("全3件中3〜3件を表示")
    end

    it "カテゴリのツリーのリンクにページのパラメータがついていないこと" do
      render

      params = @request.params.select{|k, v| k.to_s != "page"}
      rendered.should have_link(
        @foo.caption,
        :href=>tengine_job_root_jobnet_templates_path(params.merge(:category=>@foo.id))
      )
    end

    context "nameで検索していたとき" do
      before do
        @request.query_parameters[:finder] = { :name => "foo" }
      end

      it "ソートのリンクに検索のクエリーパラメータのみ付加されていること" do
        render

        query_param = {:finder => @request.query_parameters[:finder]}
        rendered.should have_link(
          Tengine::Job::RootJobnetTemplate.human_attribute_name(:id),
          :href=>tengine_job_root_jobnet_templates_path(
            query_param.merge(:sort => {:id => :asc}))
        )
        rendered.should have_link(
          Tengine::Job::RootJobnetTemplate.human_attribute_name(:name),
          :href=>tengine_job_root_jobnet_templates_path(
            query_param.merge(:sort => {:name => :asc}))
        )
        rendered.should have_link(
          Tengine::Job::RootJobnetTemplate.human_attribute_name(:description),
          :href=>tengine_job_root_jobnet_templates_path(
            query_param.merge(:sort => {:desc => :asc}))
        )
      end
    end
  end
end
