# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/root_jobnet_actuals/show.html.erb" do
  before(:each) do
    @root_jobnet_actual = assign(:root_jobnet_actual, stub_model(Tengine::Job::RootJobnetActual,
      :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
      :name => "Name",
      :server_name => "Server Name",
      :credential_name => "Credential Name",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "Description",
      :script => "Script",
      :jobnet_type_cd => 1,
      :executing_pid => "1234",
      :exit_status => "0",
      :was_expansion => false,
      :phase_cd => 20,
      :human_phase_name => "初期化済",
      :phase_key => :initialized,
      :stop_reason => "Stop Reason",
      :category => nil,
      :lock_version => 1,
      :template => nil,
      :started_at => Time.new(2011, 11, 5),
      :finished_at => Time.new(2011, 11, 6),
    ))
    @refresh_interval = assign(:refresh_interval, 15)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/4e955633c3406b3a9f000001/)
    rendered.should match(/Name/)
    rendered.should match(/Server Name/)
    rendered.should match(/Credential Name/)
    rendered.should match(/Description/)
    rendered.should match(/初期化済/)
    rendered.should match(/#{Regexp.escape(Time.new(2011, 11, 5).to_s)}/)
    rendered.should match(/#{Regexp.escape(Time.new(2011, 11, 6).to_s)}/)
  end

  it "タイトルが表示されていること" do
    render(:file => "tengine/job/root_jobnet_actuals/show")

    rendered.should have_xpath("//h1",
      :text => I18n.t("tengine.job.root_jobnet_actuals.show.title"))
  end

  it "@jobnet_actualsが空のとき構成ジョブと画面の更新間隔のフォームが表示されていないこと" do
    render

    rendered.should_not have_xpath("//h2",
      :text => I18n.t("views.pages.component_jobs_caption"))
    rendered.should_not have_xpath("//table[@class='TableBase']")
    rendered.should_not have_xpath("//form")
  end

  describe "@jobnet_actualsが空でないとき" do
    before do
      @job1 = stub_model(Tengine::Job::JobnetActual,
        :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
        :name => "job1 name",
        :description => "job1 description",
        :script => "job1 script",
        :server_name => "job1 server_name",
        :credential_name => "job1 credential_name",
        :phase_cd => 20,
        :phase_name => "initialized",
        :phase_key => :initialized,
        :started_at => Time.new(2011, 11, 5),
        :finished_at => Time.new(2011, 11, 6),
      )
      @job2 = stub_model(Tengine::Job::JobnetActual,
        :id => BSON::ObjectId("4e955633c3406b3a9f000003"),
        :name => "job2 name",
        :description => "job2 description",
        :script => "job2 script",
        :server_name => "job2 server_name",
        :credential_name => "job2 credential_name",
        :phase_cd => 20,
        :phase_name => "initialized",
        :phase_key => :initialized,
      )
      @jobnet_actuals = assign(:jobnet_actuals, [
        [@job1, 0],
        [@job2, 1],
      ])
    end

    it "@jobnet_actualsが空でないとき構成ジョブと画面の更新間隔のフォームが表示されていること" do
      render

      rendered.should have_xpath("//h2",
        :text => I18n.t("views.pages.component_jobs_caption"))
      rendered.should have_xpath("//table[@class='TableBase']")
      rendered.should have_xpath("//form")
    end

    it "構成ジョブ一覧に@jobnet_actualsの内容が表示されていること" do
      render

      rendered.should have_xpath("//td", :text => @job1.id.to_s)
      rendered.should have_xpath("//td", :text => @job1.name)
      rendered.should have_xpath("//td", :text => @job1.description)
      rendered.should have_xpath("//td", :text => @job1.script)
      rendered.should have_xpath("//td", :text => @job1.server_name)
      rendered.should have_xpath("//td", :text => @job1.credential_name)
      rendered.should have_xpath("//td", :text => @job1.human_phase_name)
      rendered.should have_xpath("//td", :text => @job1.started_at.to_s)
      rendered.should have_xpath("//td", :text => @job1.finished_at.to_s)
    end

    it "@job2のジョブ名がインデントされて表示されていること" do
      render

      space = Nokogiri::HTML('&nbsp;').text
      indent = space * 2
      rendered.should have_xpath("//td", :text => "#{indent}#{@job2.name}")
    end

    it "全体の強制停止のリンクが表示されないこと" do
      render

      rendered.should_not have_link(I18n.t("views.links.force_exit"),
        :href => tengine_job_root_jobnet_actual_path(@root_jobnet_actual))
    end

    context "@job1のステータスがinitializedのとき" do
      before do
        @job1 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
          :name => "job1 name",
          :description => "job1 description",
          :script => "job1 script",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 20,
          :phase_name => "initialized",
          :phase_key => :initialized,
          :started_at => Time.new(2011, 11, 5),
        )
        @jobnet_actuals = assign(:jobnet_actuals, [
          [@job1, 0],
        ])
      end

      it "再実行のリンクが表示されていること" do
        render

        rendered.should_not have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @job1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual.id.to_s,
            :target_actual_ids => [@job1.id.to_s],
            :retry => true))
        rendered.should_not have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job1.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end
    end

    context "@job1のステータスがreadyのとき" do
      before do
        @job1 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
          :name => "job1 name",
          :description => "job1 description",
          :script => "job1 script",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 30,
          :phase_name => "ready",
          :phase_key => :ready,
          :started_at => Time.new(2011, 11, 5),
        )
        @jobnet_actuals = assign(:jobnet_actuals, [
          [@job1, 0],
        ])
      end

      it "強制停止のリンクが表示されていないこと" do
        render

        rendered.should_not have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @job1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should_not have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual, :retry => true))
        rendered.should have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job1.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end
    end

    context "@job1のステータスがstartingのとき" do
      before do
        @job1 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
          :name => "job1 name",
          :description => "job1 description",
          :script => "job1 script",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 50,
          :phase_name => "starting",
          :phase_key => :starting,
          :started_at => Time.new(2011, 11, 5),
        )
        @jobnet_actuals = assign(:jobnet_actuals, [
          [@job1, 0],
        ])
      end

      it "強制停止のリンクが表示されていないこと" do
        render

        rendered.should_not have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @job1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should_not have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual, :retry => true))
        rendered.should have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job1.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end
    end

    context "@job1のステータスがrunningのとき" do
      before do
        @job1 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
          :name => "job1 name",
          :description => "job1 description",
          :script => "job1 script",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 60,
          :phase_name => "running",
          :phase_key => :running,
          :started_at => Time.new(2011, 11, 5),
        )
        @jobnet_actuals = assign(:jobnet_actuals, [
          [@job1, 0],
        ])
      end

      it "強制停止のリンクが表示されていること" do
        render

        rendered.should_not have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @job1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should_not have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual, :retry => true))
        rendered.should have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job1.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end
    end

    context "@job1のステータスがdyingのとき" do
      before do
        @job1 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
          :name => "job1 name",
          :description => "job1 description",
          :script => "job1 script",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 70,
          :phase_name => "dying",
          :phase_key => :dying,
          :started_at => Time.new(2011, 11, 5),
        )
        @jobnet_actuals = assign(:jobnet_actuals, [
          [@job1, 0],
        ])
      end

      it "操作のリンクが表示されていないこと" do
        render

        rendered.should_not have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @job1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should_not have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual, :retry => true))
        rendered.should_not have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job1.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end
    end

    context "@job1のステータスがsuccessのとき" do
      before do
        @job1 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
          :name => "job1 name",
          :description => "job1 description",
          :script => "job1 script",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 40,
          :phase_name => "success",
          :phase_key => :success,
          :started_at => Time.new(2011, 11, 5),
        )
        @jobnet_actuals = assign(:jobnet_actuals, [
          [@job1, 0],
        ])
      end

      it "ステータスがsuccessの場合、再実行のリンクが表示されていること" do
        render

        rendered.should_not have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @job1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual,
            :target_actual_ids => [@job1.id.to_s],
            :retry => true))
        rendered.should_not have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job1.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end
    end

    context "@job1のステータスがerrorのとき" do
      before do
        @job1 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
          :name => "job1 name",
          :description => "job1 description",
          :script => "job1 script",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 80,
          :phase_name => "error",
          :phase_key => :error,
          :started_at => Time.new(2011, 11, 5),
        )
        @jobnet_actuals = assign(:jobnet_actuals, [
          [@job1, 0],
        ])
      end

      it "ステータスがerrorの場合、再実行のリンクが表示されていること" do
        render

        rendered.should_not have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @job1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual,
            :target_actual_ids => [@job1.id.to_s],
            :retry => true))
        rendered.should_not have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job1.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end
    end

    context "@job1のステータスがstuckのとき" do
      before do
        @job1 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
          :name => "job1 name",
          :description => "job1 description",
          :script => "job1 script",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 90,
          :phase_name => "stuck",
          :phase_key => :stuck,
          :started_at => Time.new(2011, 11, 5),
        )
        @jobnet_actuals = assign(:jobnet_actuals, [
          [@job1, 0],
        ])
      end

      it "ステータス変更と再実行のリンクが表示されていること" do
        render

        rendered.should have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @job1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual,
            :target_actual_ids => [@job1.id.to_s],
            :retry => true))
        rendered.should_not have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job1.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end
    end

    context "@jobnet1のステータスがstuck, @job2のステータスがrunningのとき" do
      before do
        @jobnet1 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
          :name => "job1 name",
          :description => "job1 description",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 90,
          :phase_name => "stuck",
          :phase_key => :stuck,
          :started_at => Time.new(2011, 11, 5),
        )
        @job2 = stub_model(Tengine::Job::JobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000003"),
          :name => "job2 name",
          :description => "job2 description",
          :script => "job2 script",
          :server_name => "job1 server_name",
          :credential_name => "job1 credential_name",
          :phase_cd => 90,
          :phase_name => "running",
          :phase_key => :running,
          :started_at => Time.new(2011, 11, 5),
          :parent => @jobnet1,
        )
        @jobnet_actuals = assign(:jobnet_actuals, [
          [@jobnet1, 0],
          [@job2, 1],
        ])
      end

      it "@jobnet1はステータス変更と再実行のリンクが表示されていること" do
        render

        rendered.should have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @jobnet1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual,
            :target_actual_ids => [@jobnet1.id.to_s],
            :retry => true))
        rendered.should_not have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@jobnet1.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end

      it "@job2はステータス変更と強制停止のリンクが表示されていること" do
        render

        rendered.should have_link(I18n.t("views.links.edit_status"),
          :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
            @job2, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
        rendered.should_not have_link(I18n.t("views.links.rerun"),
          :href => new_tengine_job_execution_path(
            :root_jobnet_id => @root_jobnet_actual,
            :target_actual_ids => [@job2.id.to_s],
            :retry => true))
        rendered.should have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job2.id.to_s,
            :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
      end
    end

    context "@root_jobnet_actualのステータスがrunningのとき" do
      before(:each) do
        @root_jobnet_actual = assign(:root_jobnet_actual, stub_model(Tengine::Job::RootJobnetActual,
          :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
          :name => "Name",
          :server_name => "Server Name",
          :credential_name => "Credential Name",
          :killing_signals => ["abc", "123"],
          :killing_signal_interval => 1,
          :description => "Description",
          :script => "Script",
          :jobnet_type_cd => 1,
          :executing_pid => "1234",
          :exit_status => "0",
          :was_expansion => false,
          :phase_cd => 60,
          :phase_name => "running",
          :phase_key => :running,
          :stop_reason => "Stop Reason",
          :category => nil,
          :lock_version => 1,
          :template => nil,
          :started_at => Time.new(2011, 11, 5, 11, 11),
        ))
        @finder = assign(:finder, {:test => "foo"})
      end

      it "全体の強制停止のリンクが表示されること" do
        render

        rendered.should have_link(I18n.t("views.links.force_exit"),
          :href => tengine_job_root_jobnet_actual_path(@root_jobnet_actual))
      end

      it "メッセージ一覧のリンクが表示されていること" do
        render(:file => "tengine/job/root_jobnet_actuals/show")

        rendered.should have_link(
          I18n.t("tengine.job.root_jobnet_actuals.show.links.events"),
          :href => tengine_core_events_path(:finder => @finder, :commit => "submit")
        )
      end
    end

    context "<BUG>hadoop_job_runを含むジョブを実行すると、「ジョブネット監視」画面のhadoop_job、Map、Reduceに強制停止リンク、及び再実行リンクが表示されてしまう" do
      [:hadoop_job, :map_phase, :reduce_phase].each do |jobnet_type_key|
        context "jobnet_type_keyが#{jobnet_type_key.inspect}ならば" do
          Tengine::Job::JobnetActual.phase_keys.each do |phase_key|
            context "どんな状態でも(#{phase_key.inspect})" do
              before do
                @job1 = stub_model(Tengine::Job::JobnetActual,
                  :id => BSON::ObjectId("4e955633c3406b3a9f000002"),
                  :jobnet_type_key => jobnet_type_key,
                  :name => "job1 name",
                  :description => "job1 description",
                  :script => "job1 script",
                  :server_name => "job1 server_name",
                  :credential_name => "job1 credential_name",
                  :phase_cd => 90,
                  :phase_name => "stuck",
                  :phase_key => :stuck,
                  :started_at => Time.new(2011, 11, 5),
                  )
                @jobnet_actuals = assign(:jobnet_actuals, [
                    [@job1, 0],
                  ])
              end

              it "強制停止や再実行のリンクは表示されない" do
                render
                rendered.should_not have_link(I18n.t("views.links.edit_status"),
                  :href => edit_tengine_job_root_jobnet_actual_jobnet_actual_path(
                    @job1, :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
                rendered.should_not have_link(I18n.t("views.links.rerun"),
                  :href => new_tengine_job_execution_path(
                    :root_jobnet_id => @root_jobnet_actual,
                    :target_actual_ids => [@job1.id.to_s],
                    :retry => true))
                rendered.should_not have_link(I18n.t("views.links.force_exit"),
                  :href => tengine_job_root_jobnet_actual_jobnet_actual_path(@job1.id.to_s,
                    :root_jobnet_actual_id => @root_jobnet_actual.id.to_s))
              end

            end
          end
        end
      end
    end
  end
end
