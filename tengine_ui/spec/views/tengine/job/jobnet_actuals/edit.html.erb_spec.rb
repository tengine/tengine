# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/jobnet_actuals/edit.html.erb" do
  before(:each) do
    @root_jobnet_actual = assign(:root_jobnet_actual,
      stub_model(Tengine::Job::Runtime::RootJobnet, :name => "test root"))
    @jobnet_actual = assign(:jobnet_actual, stub_model(Tengine::Job::Runtime::Jobnet,
      :name => "test name",
      :server_name => "test server_name",
      :credential_name => "test credential_name",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "MyString",
      :script => "test script",
      :jobnet_type_cd => 1,
      :executing_pid => "1234",
      :exit_status => "MyString",
      :was_expansion => false,
      :phase_cd => 1,
      :stop_reason => "MyString",
      :started_at => Time.new(2011, 11, 10, 10, 30),
      :finished_at => Time.new(2011, 11, 10, 18, 30),
    ))
  end

  it "renders the edit jobnet_actual form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_root_jobnet_actual_jobnet_actuals_path(@jobnet_actual, :root_jobnet_actual_id => @root_jobnet_actual), :method => "post" do
      assert_select "select#jobnet_actual_phase_cd", :name => "jobnet_actual[phase_cd]"
    end

    rendered.should have_xpath("//input[@type='submit'][@class='BtnNext']")
  end

  it "ジョブネットの情報が表示されていること" do
    render

    rendered.should have_xpath("//td", :text => @jobnet_actual.name)
    rendered.should have_xpath("//td", :text => @jobnet_actual.executing_pid)
    rendered.should have_xpath("//td", :text => @jobnet_actual.script)
    rendered.should have_xpath("//td", :text => @jobnet_actual.server_name)
    rendered.should have_xpath("//td", :text => @jobnet_actual.credential_name)
    rendered.should have_xpath("//td", :text => @jobnet_actual.started_at.to_s)
    rendered.should have_xpath("//td", :text => @jobnet_actual.finished_at.to_s)
  end

  it "ページタイトルが表示されていること" do
    render(:file => "tengine/job/jobnet_actuals/edit")

    rendered.should have_xpath("//h1",
      :text => I18n.t("tengine.job.jobnet_actuals.edit.title"))
  end

  it "キャンセルのリンクが表示されていること" do
    render

    rendered.should have_xpath("//a[@href='#{tengine_job_root_jobnet_actual_path(@root_jobnet_actual)}']", :text => I18n.t("views.links.cancel"))
  end
end
