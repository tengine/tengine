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
        @actual1 = stub_model(Tengine::Job::RootJobnetActual,
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
          :human_phase_name => "初期化済",
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
          :human_phase_name => "初期化済",
          :lock_version => 4,
          :template => stub_template
        )
      ]
      assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))

      finder = Tengine::Job::RootJobnetActual::Finder.new
      finder.stub(:phase_hash_array).and_return([{
        :id=>20, :key=>:test, :name=>"test phase", :select=>true,
      }])
      assign(:finder, finder)
    end

    it "renders a list of tengine_job_root_jobnet_actuals" do
      render

      assert_select "tr>td", :text => BSON::ObjectId("4e955633c3406b3a9f000001").to_s
      assert_select "tr>td", :text => "Name".to_s, :count => 2
      assert_select "tr>td", :text => "Description".to_s, :count => 2
      assert_select "tr>td", :text => "初期化済", :count => 2
    end

    it "ページタイトルが表示されていること" do
      render

      title = page_title(Tengine::Job::RootJobnetActual, :list)
      rendered.should have_xpath("//h1", :text => title)
    end

    it "期間選択のフィールドが表示されてること" do
      render

      rendered.should have_xpath("//select[@id='finder_duration']", :count => 1)
      rendered.should have_xpath("//option[@value='started_at']", :count => 1)
      rendered.should have_xpath("//option[@value='finished_at']", :count => 1)
    end

    it "期間の日時を選択するフィールドが表示されていること" do
      render

      render.should have_xpath("//select[@id='finder_duration_start_1i']", :count => 1)
      render.should have_xpath("//select[@id='finder_duration_start_4i']", :count => 1)
      render.should have_xpath("//select[@id='finder_duration_finish_1i']", :count => 1)
      render.should have_xpath("//select[@id='finder_duration_finish_4i']", :count => 1)
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

    it "監視のリンクが表示されていること" do
      render

      href = tengine_job_root_jobnet_actual_path(@actual1)
      rendered.should have_xpath("//a[@href='#{href}']",
        :text => I18n.t("views.links.watch"))
    end

    it "ソートのリンクが表示されていること" do
      render

      href = tengine_job_root_jobnet_actuals_path(:sort=>{:id=>"asc"})
      rendered.should have_xpath("//a[@class=''][@href='#{href}']",
        :text => Tengine::Job::RootJobnetActual.human_attribute_name(:id))
      href = tengine_job_root_jobnet_actuals_path(:sort=>{:name=>"asc"})
      rendered.should have_xpath("//a[@class=''][@href='#{href}']",
        :text => Tengine::Job::RootJobnetActual.human_attribute_name(:name))
      href = tengine_job_root_jobnet_actuals_path(:sort=>{:description=>"asc"})
      rendered.should have_xpath("//a[@class=''][@href='#{href}']",
        :text => Tengine::Job::RootJobnetActual.human_attribute_name(:description))
      href = tengine_job_root_jobnet_actuals_path(:sort=>{:phase_cd=>"asc"})
      rendered.should have_xpath("//a[@class=''][@href='#{href}']",
        :text => Tengine::Job::RootJobnetActual.human_attribute_name(:phase_cd))
      href = tengine_job_root_jobnet_actuals_path(:sort=>{:started_at=>"asc"})
      rendered.should have_xpath("//a[@class=''][@href='#{href}']",
        :text => Tengine::Job::RootJobnetActual.human_attribute_name(:started_at))
      href = tengine_job_root_jobnet_actuals_path(:sort=>{:finished_at=>"asc"})
      rendered.should have_xpath("//a[@class=''][@href='#{href}']",
        :text => Tengine::Job::RootJobnetActual.human_attribute_name(:finished_at))
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

      it "検索フォームのhiddenフィールドにcategoryのフィールドがないこと" do
        render

        rendered.should_not have_xpath("//input[@type='hidden'][@id='category']")
      end

      it "@refresh_intervalの値が絞り込みのフォームのhiddenフィールドとしてあること" do
        finder = Tengine::Job::RootJobnetActual::Finder.new(refresh_interval:10)
        assign(:finder, finder)

        render

        rendered.should have_xpath("//input[@type='hidden'][@id='hidden_finder_refresh_interval'][@value='10']")
      end

      it "@finderの値が画面の更新間隔のフォームのhiddenフィールドとしてあること" do
        finder = Tengine::Job::RootJobnetActual::Finder.new(
          duration:"finished_at",
          "duration_start(0i)" => "2011",
          "duration_start(1i)" => "11",
          "duration_start(2i)" => "11",
          "duration_start(3i)" => "11",
          "duration_start(4i)" => "11",
          "duration_finish(0i)" => "2012",
          "duration_finish(1i)" => "11",
          "duration_finish(2i)" => "11",
          "duration_finish(3i)" => "11",
          "duration_finish(4i)" => "11",
          id:"12344",
          name:"testname",
        )
        finder.stub(:phase_ids).and_return(["20", "30"])

        assign(:finder, finder)

        render

        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration'][@value='finished_at']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_start_0i_'][@value='2011']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_start_1i_'][@value='11']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_start_2i_'][@value='11']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_start_3i_'][@value='11']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_start_4i_'][@value='11']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_finish_0i_'][@value='2012']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_finish_1i_'][@value='11']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_finish_2i_'][@value='11']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_finish_3i_'][@value='11']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_duration_finish_4i_'][@value='11']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_id'][@value='12344']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_name'][@value='testname']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_phase_ids_'][@value='20']")
        rendered.should have_xpath("//form[@method='get']/input[@type='hidden'][@id='hidden_finder_phase_ids_'][@value='30']")
      end

      context "@categoryが設定されているとき" do
        before do
          @category = @foo
          @request.query_parameters[:category] = @category.id
        end

        it "検索フォームのhiddenフィールドに@category.idが設定されていること" do
          render

          rendered.should have_xpath("//input[@type='hidden'][@id='category'][@value='#{@category.id}']", :count => 1)
        end

        it "ソートのリンクにcategoryパラメータがついていること" do
          render

          href = tengine_job_root_jobnet_actuals_path(
            :sort => {:id => 'asc'}, :category => @category.id)
          rendered.should have_xpath("//a[@href='#{href}']",
            :text => Tengine::Job::RootJobnetActual.human_attribute_name(:id))
        end
      end

      context "nameで検索したとき" do
        before do
          @request.query_parameters[:finder] = {:name => "foo"}
        end

        it "ソートのリンクにfinderパラメータがついていること" do
          render

          href = tengine_job_root_jobnet_actuals_path(
            :sort => {:id => 'asc'}, :finder => {:name => 'foo'})
          rendered.should have_xpath("//a[@href='#{href}']",
            :text => Tengine::Job::RootJobnetActual.human_attribute_name(:id))
        end

        it "カテゴリツリーのリンクにfinderパラメータがついていること" do
          render

          href = tengine_job_root_jobnet_actuals_path(:finder => {:name => 'foo'})
          rendered.should have_xpath("//a[@href='#{href}']",
            :text => I18n.t("views.category_tree.all"))
        end
      end

      context "表示名の昇順でソートしたとき" do
        before do
          @request.query_parameters[:sort] = {:description => "asc"}
        end

        it "表示名のソートのリンクに降順のパラメータがついていてclassがSortAscであること" do
          render

          href = tengine_job_root_jobnet_actuals_path(:sort => {:description => 'desc'})
          rendered.should have_xpath("//a[@href='#{href}'][@class='SortAsc']",
            :text => Tengine::Job::RootJobnetActual.human_attribute_name(:description))
        end

        it "名称のソートのリンクに昇順のパラメータがついていてclassがないこと" do
          render

          href = tengine_job_root_jobnet_actuals_path(:sort => {:name => 'asc'})
          rendered.should have_xpath("//a[@href='#{href}'][@class='']",
            :text => Tengine::Job::RootJobnetActual.human_attribute_name(:name))
        end
      end
    end

    context "@finderが設定されているとき" do
      before do
        @finder = Tengine::Job::RootJobnetActual::Finder.new({
          :duration => "started_at",
          :duration_start => Time.new(2011, 11, 6, 10, 30),
          :duration_finish => Time.new(2011, 11, 6, 12, 30),
          :id => "10",
          :name => "test name",
          :phase_ids => ["20"],
          #:refresh_interval => "20", # 更新間隔
        })

        @finder.stub(:phase_hash_array).and_return([{
          :id=>20, :key=>:test, :name=>"test phase", :select=>true,
        }])
        assign(:finder, @finder)
      end

      it "@finderの値が検索のフィールドに設定されていること" do
        render

        rendered.should have_xpath("//input[@id='finder_id'][@value='10']")
        rendered.should have_xpath("//input[@id='finder_name'][@value='test name']")
      end
    end

    context "フェーズがrunningのTengine::Job::RootJobnetActualが登録されているとき" do
      before do
        stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
        templates = [
          @actual1 = stub_model(Tengine::Job::RootJobnetActual,
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
            :phase_cd => 60,
            :phase_name => "initialized",
            :stop_reason => "Stop Reason",
            :lock_version => 4,
            :template => stub_template
          ),
        ]
        assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))
      end

      it "強制停止のリンクが表示されていること" do
        render

        rendered.should have_xpath("//a", :text => I18n.t("views.links.force_exit"))
      end

      it "再実行のリンクが表示されていないこと" do
        render

        href = new_tengine_job_execution_path(
          :root_jobnet_id => @actual1, :retry => true)
        rendered.should_not have_xpath("//a[@href='#{href}']",
          :text => I18n.t("views.links.rerun"))
      end
    end

    context "フェーズがreadyのTengine::Job::RootJobnetActualが登録されているとき" do
      before do
        stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
        templates = [
          @actual1 = stub_model(Tengine::Job::RootJobnetActual,
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
            :phase_cd => 30,
            :phase_name => "initialized",
            :stop_reason => "Stop Reason",
            :lock_version => 4,
            :template => stub_template
          ),
        ]
        assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))
      end

      it "強制停止のリンクが表示されていること" do
        render

        rendered.should have_xpath("//a", :text => I18n.t("views.links.force_exit"))
      end

      it "再実行のリンクが表示されていないこと" do
        render

        href = new_tengine_job_execution_path(
          :root_jobnet_id => @actual1, :retry => true)
        rendered.should_not have_xpath("//a[@href='#{href}']",
          :text => I18n.t("views.links.rerun"))
      end
    end

    context "フェーズがstartingのTengine::Job::RootJobnetActualが登録されているとき" do
      before do
        stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
        templates = [
          @actual1 = stub_model(Tengine::Job::RootJobnetActual,
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
            :phase_cd => 50,
            :phase_name => "initialized",
            :stop_reason => "Stop Reason",
            :lock_version => 4,
            :template => stub_template
          ),
        ]
        assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))
      end

      it "強制停止のリンクが表示されていること" do
        render

        rendered.should have_xpath("//a", :text => I18n.t("views.links.force_exit"))
      end

      it "再実行のリンクが表示されていないこと" do
        render

        href = new_tengine_job_execution_path(
          :root_jobnet_id => @actual1, :retry => true)
        rendered.should_not have_xpath("//a[@href='#{href}']",
          :text => I18n.t("views.links.rerun"))
      end
    end

    context "フェーズがdyingのTengine::Job::RootJobnetActualが登録されているとき" do
      before do
        stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
        templates = [
          @actual1 = stub_model(Tengine::Job::RootJobnetActual,
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
            :phase_cd => 70,
            :phase_name => "initialized",
            :stop_reason => "Stop Reason",
            :lock_version => 4,
            :template => stub_template
          ),
        ]
        assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))
      end

      it "強制停止のリンクが表示されていないこと" do
        render

        rendered.should_not have_xpath("//a", :text => I18n.t("views.links.force_exit"))
      end

      it "再実行のリンクが表示されていないこと" do
        render

        href = new_tengine_job_execution_path(
          :root_jobnet_id => @actual1, :retry => true)
        rendered.should_not have_xpath("//a[@href='#{href}']",
          :text => I18n.t("views.links.rerun"))
      end
    end

    context "フェーズがinitializedのTengine::Job::RootJobnetActualが登録されているとき" do
      before do
        stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
        templates = [
          @actual1 = stub_model(Tengine::Job::RootJobnetActual,
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
        ]
        assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))
      end

      it "強制停止のリンクが表示されていないこと" do
        render

        rendered.should_not have_xpath("//a", :text => I18n.t("views.links.force_exit"))
      end

      it "再実行のリンクが表示されていること" do
        render

        href = new_tengine_job_execution_path(
          :root_jobnet_id => @actual1, :retry => true)
        rendered.should have_xpath("//a[@href='#{href}']",
          :text => I18n.t("views.links.rerun"))
      end
    end

    context "フェーズがsuccessのTengine::Job::RootJobnetActualが登録されているとき" do
      before do
        stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
        templates = [
          @actual1 = stub_model(Tengine::Job::RootJobnetActual,
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
            :phase_cd => 40,
            :phase_name => "initialized",
            :stop_reason => "Stop Reason",
            :lock_version => 4,
            :template => stub_template
          ),
        ]
        assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))
      end

      it "強制停止のリンクが表示されていないこと" do
        render

        rendered.should_not have_xpath("//a", :text => I18n.t("views.links.force_exit"))
      end

      it "再実行のリンクが表示されていること" do
        render

        href = new_tengine_job_execution_path(
          :root_jobnet_id => @actual1, :retry => true)
        rendered.should have_xpath("//a[@href='#{href}']",
          :text => I18n.t("views.links.rerun"))
      end
    end

    context "フェーズがerrorのTengine::Job::RootJobnetActualが登録されているとき" do
      before do
        stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
        templates = [
          @actual1 = stub_model(Tengine::Job::RootJobnetActual,
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
            :phase_cd => 80,
            :phase_name => "initialized",
            :stop_reason => "Stop Reason",
            :lock_version => 4,
            :template => stub_template
          ),
        ]
        assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))
      end

      it "強制停止のリンクが表示されていないこと" do
        render

        rendered.should_not have_xpath("//a", :text => I18n.t("views.links.force_exit"))
      end

      it "再実行のリンクが表示されていること" do
        render

        href = new_tengine_job_execution_path(
          :root_jobnet_id => @actual1, :retry => true)
        rendered.should have_xpath("//a[@href='#{href}']",
          :text => I18n.t("views.links.rerun"))
      end
    end

    context "フェーズがstuckのTengine::Job::RootJobnetActualが登録されているとき" do
      before do
        stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
        templates = [
          @actual1 = stub_model(Tengine::Job::RootJobnetActual,
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
            :phase_key => :stuck,
            :phase_name => "stuck",
            :stop_reason => "Stop Reason",
            :lock_version => 4,
            :template => stub_template
          ),
        ]
        assign(:root_jobnet_actuals, Kaminari.paginate_array(templates).page(1).per(5))
      end

      it "ステータス変更のリンクが表示されていること" do
        render

        href = edit_tengine_job_root_jobnet_actual_path(@actual1)
        rendered.should have_xpath("//a[@href='#{href}']",
          :text => I18n.t("views.links.edit_status"))
      end

      it "強制停止のリンクが表示されていないこと" do
        render

        rendered.should_not have_xpath("//a", :text => I18n.t("views.links.force_exit"))
      end

      it "再実行のリンクが表示されていること" do
        render

        href = new_tengine_job_execution_path(
          :root_jobnet_id => @actual1, :retry => true)
        rendered.should have_xpath("//a[@href='#{href}']",
          :text => I18n.t("views.links.rerun"))
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

      finder = Tengine::Job::RootJobnetActual::Finder.new
      finder.stub(:phase_hash_array).and_return([{
        :id=>20, :key=>:test, :name=>"test phase", :select=>true,
      }])
      assign(:finder, finder)
    end

    it "ページネーションのリンクが表示されていること" do
      render

      rendered.should have_xpath("//div[@class='PageStats']", :count => 2)
    end

    context "ページ移動したとき" do
      before do
        @request.query_parameters[:page] = 2
      end

      it "ソートのリンクにpageパラメータがついていないこと" do
        render

        href = tengine_job_root_jobnet_actuals_path(:sort => {:name => 'asc'})
        rendered.should have_xpath("//a[@href='#{href}']",
          :text => Tengine::Job::RootJobnetActual.human_attribute_name(:name))
      end

      context "カテゴリが登録されているとき" do
        before do
          Tengine::Job::Category.delete_all
          @foo = stub_model(Tengine::Job::Category,
            :id => BSON::ObjectId("4e855633c3406b3a9f000001"),
            :dsl_verion => 0,
            :name => "foo",
            :caption => "ふー",
            :parent_id => nil,
          )
          assign(:root_categories, [@foo])
        end

        it "カテゴリのリンクにpageパラメータがついていないこと" do
          render

          href = tengine_job_root_jobnet_actuals_path(:category => @foo.id)
          rendered.should have_xpath("//a[@href='#{href}']",
            :text => @foo.caption)
        end
      end
    end
  end
end
