# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/root_jobnet_actuals/index.html.erb" do
  context "ページネーションのページが1ページのみのとき" do
    before(:each) do
      Tengine::Job::Category.delete_all
      Tengine::Job::RootJobnetTemplate.delete_all
      Tengine::Job::RootJobnetActual.delete_all
      stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
      templates = [
        stub_model(Tengine::Job::RootJobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
          :name => "Name",
          :server_name => "Server Name",
          :credential_name => "Credential Name",
          :killing_signals => ["abc", "123"],
          :killing_signal_interval => 1,
          :description => "Description",
          :script => "Script",
          :jobnet_type_cd => 2,
          :executing_pid => "Executing Pid",
          :exit_status => "Exit Status",
          :was_expansion => false,
          :phase_cd => 20,
          :phase_name => "initialized",
          :stop_reason => "Stop Reason",
          :lock_version => 4,
          :template => stub_template
        ),
        stub_model(Tengine::Job::RootJobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
          :name => "Name",
          :server_name => "Server Name",
          :credential_name => "Credential Name",
          :killing_signals => ["abc", "123"],
          :killing_signal_interval => 1,
          :description => "Description",
          :script => "Script",
          :jobnet_type_cd => 2,
          :executing_pid => "Executing Pid",
          :exit_status => "Exit Status",
          :was_expansion => false,
          :phase_cd => 20,
          :phase_name => "initialized",
          :stop_reason => "Stop Reason",
          :lock_version => 4,
          :template => stub_template
        )
      ]
      assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))
    end

    it "renders a list of tengine_job_root_jobnet_actuals" do
      render

      assert_select "tr>td", :text => BSON::ObjectId("4e955633c3406b3a9f000001").to_s
      assert_select "tr>td", :text => "Name".to_s, :count => 2
      assert_select "tr>td", :text => "Description".to_s, :count => 2
      assert_select "tr>td", :text => "initialized", :count => 2
    end

    it "ページタイトルが表示されていること" do
      render

      title = page_title(Tengine::Job::RootJobnetActual, :list)
      rendered.should have_xpath("//h1", :text => title)
    end

    it "期間選択のフィールドが表示されてること" do
      render

      rendered.should have_xpath("//select[@id='finder_time']", :count => 1)
    end

    it "期間の日時を選択するフィールドが表示されていること" do
      render

      render.should have_xpath("//select[@id='finder_started_at_1i']", :count => 1)
      render.should have_xpath("//select[@id='finder_started_at_4i']", :count => 1)
      render.should have_xpath("//select[@id='finder_finished_at_1i']", :count => 1)
      render.should have_xpath("//select[@id='finder_finished_at_4i']", :count => 1)
    end

    it "IDの検索フィールドが表示されていること" do
      render

      rendered.should have_xpath("//input[@type='text'][@id='finder_id']", :count => 1)
    end

    it "名称の検索フィールドが表示されていること" do
      render

      rendered.should have_xpath("//input[@type='text'][@id='finder_name']", :count => 1)
    end

    it "検索ボタンが表示されていること" do
      render

      rendered.should have_button(I18n.t("views.links.search"))
    end

    it "リセットボタンが表示されていること" do
      render

      rendered.should have_xpath(%|//input[@type='reset'][@value='#{I18n.t("views.links.reset")}']|, :count => 1)
    end

    context "カテゴリが登録されているとき" do
      before do
        Tengine::Job::Category.delete_all
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
      end

      it "カテゴリツリーが表示されていること" do
        render

        rendered.should have_xpath("//ul[@id='category']")
      end
    end
  end

  context "ページネーションのページが2ページ以上のとき" do
    before do
      Tengine::Job::Category.delete_all
      Tengine::Job::RootJobnetTemplate.delete_all
      Tengine::Job::RootJobnetActual.delete_all
      stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
      templates = [
        stub_model(Tengine::Job::RootJobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
          :name => "Name",
          :server_name => "Server Name",
          :credential_name => "Credential Name",
          :killing_signals => ["abc", "123"],
          :killing_signal_interval => 1,
          :description => "Description",
          :script => "Script",
          :jobnet_type_cd => 2,
          :executing_pid => "Executing Pid",
          :exit_status => "Exit Status",
          :was_expansion => false,
          :phase_cd => 20,
          :phase_name => "initialized",
          :stop_reason => "Stop Reason",
          :lock_version => 4,
          :template => stub_template
        ),
        stub_model(Tengine::Job::RootJobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
          :name => "Name",
          :server_name => "Server Name",
          :credential_name => "Credential Name",
          :killing_signals => ["abc", "123"],
          :killing_signal_interval => 1,
          :description => "Description",
          :script => "Script",
          :jobnet_type_cd => 2,
          :executing_pid => "Executing Pid",
          :exit_status => "Exit Status",
          :was_expansion => false,
          :phase_cd => 20,
          :phase_name => "initialized",
          :stop_reason => "Stop Reason",
          :lock_version => 4,
          :template => stub_template
        )
      ]
      assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(1))
    end

    it "ページネーションのリンクが表示されていること" do
      render

      rendered.should have_xpath("//nav[@class='pagination']", :count => 2)
    end
  end
end
