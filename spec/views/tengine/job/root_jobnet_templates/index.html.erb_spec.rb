# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/root_jobnet_templates/index.html.erb" do
  before(:each) do
    category = stub_model(Tengine::Job::Category, :to_s => "category")
    mock_pagination(assign(:root_jobnet_templates, [
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
    ]))
  end

  it "renders a list of tengine_job_root_jobnet_templates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => BSON::ObjectId("4e955633c3406b3a9f000001").to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end

  it "idのソートのリンクに昇順のクエリーパラメータが付加されていること" do
    render

    rendered.should have_link(
      Tengine::Job::RootJobnetTemplate.human_attribute_name(:id),
      :href=>tengine_job_root_jobnet_templates_path(:sort=>{:id=>:asc}))
  end

  it "nameのソートのリンクに昇順のクエリーパラメータが付加されていること" do
    render

    rendered.should have_link(
      Tengine::Job::RootJobnetTemplate.human_attribute_name(:name),
      :href=>tengine_job_root_jobnet_templates_path(:sort=>{:name=>:asc}))
  end

  it "descriptionのソートのリンクに昇順のクエリーパラメータが付加されていること" do
    render

    rendered.should have_link(
      Tengine::Job::RootJobnetTemplate.human_attribute_name(:description),
      :href=>tengine_job_root_jobnet_templates_path(:sort=>{:desc=>:asc}))
  end

  context "idの昇順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"id" => "asc"}
    end

    it "idのソートのリンクに降順のクエリーパラメータが付加されていること" do
      render

      rendered.should have_link(
        Tengine::Job::RootJobnetTemplate.human_attribute_name(:id),
        :href=>tengine_job_root_jobnet_templates_path(:sort=>{:id=>:desc}))
    end
  end

  context "idの降順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"id" => "desc"}
    end

    it "idのソートのリンクに昇順のクエリーパラメータが付加されていること" do
      render

      rendered.should have_link(
        Tengine::Job::RootJobnetTemplate.human_attribute_name(:id),
        :href=>tengine_job_root_jobnet_templates_path(:sort=>{:id=>:asc}))
    end
  end

  context "nameの昇順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"name" => "asc"}
    end

    it "nameのソートのリンクに降順のクエリーパラメータが付加されていること" do
      render

      rendered.should have_link(
        Tengine::Job::RootJobnetTemplate.human_attribute_name(:name),
        :href=>tengine_job_root_jobnet_templates_path(:sort=>{:name=>:desc}))
    end
  end

  context "nameの降順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"name" => "desc"}
    end

    it "nameのソートのリンクに昇順のクエリーパラメータが付加されていること" do
      render

      rendered.should have_link(
        Tengine::Job::RootJobnetTemplate.human_attribute_name(:name),
        :href=>tengine_job_root_jobnet_templates_path(:sort=>{:name=>:asc}))
    end
  end

  context "descriptionの昇順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"desc" => "asc"}
    end

    it "descriptionのソートのリンクに降順のクエリーパラメータが付加されていること" do
      render

      rendered.should have_link(
        Tengine::Job::RootJobnetTemplate.human_attribute_name(:description),
        :href=>tengine_job_root_jobnet_templates_path(:sort=>{:desc=>:desc}))
    end
  end

  context "descriptionの降順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"desc" => "desc"}
    end

    it "descriptionのソートのリンクに昇順のクエリーパラメータが付加されていること" do
      render

      rendered.should have_link(
        Tengine::Job::RootJobnetTemplate.human_attribute_name(:description),
        :href=>tengine_job_root_jobnet_templates_path(:sort=>{:desc=>:asc}))
    end
  end
end
