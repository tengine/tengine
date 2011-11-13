# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/jobnet_actuals/edit.html.erb" do
  before(:each) do
    @jobnet_actual = assign(:jobnet_actual, stub_model(Tengine::Job::JobnetActual,
      :name => "test name",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "MyString",
      :script => "MyString",
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
    assert_select "form", :action => tengine_job_jobnet_actuals_path(@jobnet_actual), :method => "post" do
      assert_select "select#jobnet_actual_phase_cd", :name => "jobnet_actual[phase_cd]"
    end
    render.should have_xpath("//input[@type='hidden'][@id='root_jobnet_id']")
  end

  it "ジョブネットの情報が表示されていること" do
    render

    rendered.should have_xpath("//td", :text => @jobnet_actual.name)
    rendered.should have_xpath("//td", :text => @jobnet_actual.executing_pid)
    rendered.should have_xpath("//td", :text => @jobnet_actual.started_at.to_s)
    rendered.should have_xpath("//td", :text => @jobnet_actual.finished_at.to_s)
  end
end
