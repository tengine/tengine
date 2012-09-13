# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/executions/new.html.erb" do
# for i18n lazy lookup
def render
  super(:file => "tengine/job/executions/new")
end

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
        :id => Moped::BSON::ObjectId("4e955633c3406b3a9f000001"),
        :name => "Name",
        :description => "Description",
        :script => "Script",
        :dsl_filepath => "Dsl Filepath",
      )
      assign(:root_jobnet, @test)
    end

    it "renders new execution form" do
      render

      rendered.should_not have_xpath("//input[@id='execution_spot_false'][@type='radio']")
      rendered.should_not have_xpath("//input[@id='execution_spot_true'][@type='radio']")
      rendered.should have_xpath("//input[@id='execution_preparation_command'][@type='text']")
      rendered.should have_xpath("//input[@id='execution_actual_base_timeout_alert'][@type='number']")
      rendered.should have_xpath("//input[@id='execution_actual_base_timeout_termination'][@type='number']")
      rendered.should_not have_xpath("//input[@id='execution_retry'][@type='hidden']")
      rendered.should_not have_xpath("//input[@id='execution_target_actual_ids_text'][@type='hidden']")
    end

    it "実行のタイトルが表示されていること" do
      render

      rendered.should have_xpath("//h1",
        :text => I18n.t("tengine.job.executions.new.title"))
    end

    it "対象のジョブネットの情報が表示されていること" do
      render

      rendered.should have_xpath("//td", :text => @test.id.to_s)
      rendered.should have_xpath("//td", :text => @test.name)
      rendered.should have_xpath("//td", :text => @test.description)
    end

    it "テンプレート参照画面へのリンクが表示されていること" do
      render

      rendered.should have_link(@test.id.to_s,
        :href => tengine_job_root_jobnet_template_path(@test.id.to_s))
    end

    it "キャンセルのリンクが表示されていること" do
      render

      rendered.should have_link(I18n.t("views.links.cancel"),
        :href => tengine_job_root_jobnet_templates_path)
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
      Tengine::Job::RootJobnetActual.delete_all
      @test_template = stub_model(Tengine::Job::RootJobnetTemplate,
        :id => Moped::BSON::ObjectId("4e955633c3406b3a9f000005"),
        :name => "Name",
        :description => "Description",
        :script => "Script",
        :dsl_filepath => "Dsl Filepath",
      )
      @test = stub_model(Tengine::Job::RootJobnetActual,
        :id => Moped::BSON::ObjectId("4e955633c3406b3a9f000001"),
        :name => "Name",
        :description => "Description",
        :script => "Script",
        :template_id => @test_template.id.to_s,
        :template => @test_template,
      )
      assign(:retry, true)
      assign(:root_jobnet, @test)
    end

    describe "ルートジョブネットの最初から再実行のとき" do
      before do
        assign(:select_root_jobnet, true)
        assign(:target_actual_ids, [@test.id.to_s])
      end

      it "renders new execution form" do
        render

        rendered.should_not have_xpath("//input[@id='execution_spot_false'][@type='radio']")
        rendered.should_not have_xpath("//input[@id='execution_spot_true'][@type='radio']")
        rendered.should have_xpath("//input[@id='execution_preparation_command'][@type='text']")
        rendered.should have_xpath("//input[@id='execution_actual_base_timeout_alert'][@type='number']")
        rendered.should have_xpath("//input[@id='execution_actual_base_timeout_termination'][@type='number']")
        rendered.should have_xpath("//input[@id='execution_retry'][@type='hidden']")
        rendered.should have_xpath("//input[@id='execution_target_actual_ids_text'][@type='hidden']")
      end

      it "再実行のタイトルが表示されていること" do
        render

        rendered.should have_xpath("//h1",
          :text => I18n.t("tengine.job.executions.new.retry_title"))
      end

      it "対象のジョブネットの情報が表示されていること" do
        render

        rendered.should have_xpath("//td", :text => @test.template_id.to_s)
        rendered.should have_xpath("//td", :text => @test.name)
        rendered.should have_xpath("//td", :text => @test.description)
      end

      it "テンプレート参照画面へのリンクが表示されていること" do
        render

        rendered.should have_link(@test.template_id.to_s,
          :href => tengine_job_root_jobnet_template_path(@test.template_id.to_s))
      end

      it "キャンセルのリンクが表示されていること" do
        render

        rendered.should have_link(I18n.t("views.links.cancel"),
          :href => tengine_job_root_jobnet_actuals_path)
      end
    end

    describe "ルートジョブネットの子から再実行のとき" do
      before do
        assign(:select_root_jobnet, false)
        assign(:target_actual_ids, ["4e955633c3406b3a9f000002"])
      end

      it "renders new execution form" do
        render

        rendered.should have_xpath("//input[@id='execution_spot_false'][@type='radio']")
        rendered.should have_xpath("//input[@id='execution_spot_true'][@type='radio']")
        rendered.should have_xpath("//input[@id='execution_preparation_command'][@type='text']")
        rendered.should have_xpath("//input[@id='execution_actual_base_timeout_alert'][@type='number']")
        rendered.should have_xpath("//input[@id='execution_actual_base_timeout_termination'][@type='number']")
        rendered.should have_xpath("//input[@id='execution_retry'][@type='hidden']")
        rendered.should have_xpath("//input[@id='execution_target_actual_ids_text'][@type='hidden']")
      end

      it "再実行のタイトルが表示されていること" do
        render

        rendered.should have_xpath("//h1",
          :text => I18n.t("tengine.job.executions.new.retry_title"))
      end

      it "対象のジョブネットの情報が表示されていること" do
        render

        rendered.should have_xpath("//td", :text => @test.template_id.to_s)
        rendered.should have_xpath("//td", :text => @test.name)
        rendered.should have_xpath("//td", :text => @test.description)
      end

      it "テンプレート参照画面へのリンクが表示されていること" do
        render

        rendered.should have_link(@test.template_id.to_s,
          :href => tengine_job_root_jobnet_template_path(@test.template_id.to_s))
      end
    end
  end
end
