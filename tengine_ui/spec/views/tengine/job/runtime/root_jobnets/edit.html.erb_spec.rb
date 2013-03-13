# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/runtime/root_jobnets/edit.html.erb" do
  before(:each) do
    @root_jobnet_actual = assign(:root_jobnet_actual, stub_model(Tengine::Job::Runtime::RootJobnet,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "MyString",
      :script => "MyString",
      :jobnet_type_cd => 1,
      :executing_pid => "MyString",
      :exit_status => "MyString",
      :was_expansion => false,
      :phase_cd => 1,
      :stop_reason => "MyString",
      :category => nil,
      :lock_version => 1,
      :template => nil
    ))
  end

  it "renders the edit root_jobnet_actual form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_runtime_root_jobnets_path(@root_jobnet_actual), :method => "post" do
      assert_select "select#root_jobnet_actual_phase_cd", :name => "root_jobnet_actual[phase_cd]"
    end
  end

  it "ジョブネットの情報が表示されていること" do
    render

    rendered.should have_xpath("//td", :text => @root_jobnet_actual.name)
    rendered.should have_xpath("//td", :text => @root_jobnet_actual.id.to_s)
    rendered.should have_xpath("//td", :text => @root_jobnet_actual.description)
    rendered.should have_xpath("//td", :text => @root_jobnet_actual.server_name)
    rendered.should have_xpath("//td", :text => @root_jobnet_actual.credential_name)
    rendered.should have_xpath("//td", :text => @root_jobnet_actual.started_at.to_s)
    rendered.should have_xpath("//td", :text => @root_jobnet_actual.finished_at.to_s)
  end

  it "ページタイトルが表示されていること" do
    render(:file => "tengine/job/runtime/root_jobnets/edit")

    rendered.should have_xpath("//h1",
      :text => I18n.t("tengine.job.runtime.root_jobnets.edit.title"))
  end

  it "キャンセルのリンクが表示されていること" do
    render

    rendered.should have_xpath("//a[@href='#{tengine_job_runtime_root_jobnets_path}']", :text => I18n.t("views.links.cancel"))
  end

end
