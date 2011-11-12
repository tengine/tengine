# -*- coding: utf-8 -*-
require 'spec_helper'

# for i18n lazy lookup
def render
  suprt(:file => "tengine/job/executions/new")
end

describe "tengine/job/executions/new.html.erb" do
  describe "テンプレートジョブネットの実行のとき" do
    before(:each) do
      assign(:execution, stub_model(Tengine::Job::Execution,
        :root_jobnet => nil,
        :target_actual_ids => nil,
        :phase_cd => 20,
        :preparation_command => "",
        :actual_base_timeout_alert => 0,
        :actual_base_timeout_termination => 0,
        :estimated_time => nil,
        :keeping_stdout => false,
        :keeping_stderr => false
      ).as_new_record)
      Tengine::Job::RootJobnetTemplate.delete_all
      @test = stub_model(Tengine::Job::RootJobnetTemplate,
        :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
        :name => "Name",
        :description => "Description",
        :script => "Script",
        :dsl_filepath => "Dsl Filepath",
      )
      assign(:root_jobnet, @test)
    end

    it "renders new execution form" do
      render

      rendered.should have_xpath("//input[@id='execution_preparation_command'][@type='text']")
      rendered.should have_xpath("//input[@id='execution_actual_base_timeout_alert'][@type='number']")
      rendered.should have_xpath("//input[@id='execution_actual_base_timeout_termination'][@type='number']")
    end

    it "実行のタイトルが表示されていること" do
      render

      rendered.should have_xpath("//h1")
    end
    #it "2実行のタイトルが表示されていること" do
    #  render(:file => "tengine/job/executions/new")

    #  rendered.should have_xpath("//h1", :text => I18n.t("tengine.job.executions.new.title"))
    #end

    it "対象のジョブネットの情報が表示されていること" do
      render

      rendered.should have_xpath("//td", :text => @test.id.to_s)
      rendered.should have_xpath("//td", :text => @test.name)
      rendered.should have_xpath("//td", :text => @test.description)
      #rendered.should have_xpath("//td", :text => @test.dsl_filepath)
    end
  end

  describe "実行ジョブネットの再実行のとき" do
    before do
      assign(:execution, stub_model(Tengine::Job::Execution,
        :root_jobnet => nil,
        :target_actual_ids => nil,
        :phase_cd => 20,
        :preparation_command => "",
        :actual_base_timeout_alert => 0,
        :actual_base_timeout_termination => 0,
        :estimated_time => nil,
        :keeping_stdout => false,
        :keeping_stderr => false
      ).as_new_record)
      Tengine::Job::RootJobnetTemplate.delete_all
      @test = stub_model(Tengine::Job::RootJobnetActual,
        :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
        :name => "Name",
        :description => "Description",
        :script => "Script",
      )
      assign(:root_jobnet, @test)
    end

    it "再実行のタイトルが表示されていること" do
      render

      rendered.should have_xpath("//h1")
    end
  end
end
