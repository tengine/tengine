# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/job/jobnet_actuals/show.html.erb" do
  before(:each) do
    assign(:root_jobnet_actual, stub_model(Tengine::Job::Runtime::RootJobnet,
      :name => "test"
    ))
    @jobnet_actual = assign(:jobnet_actual, stub_model(Tengine::Job::Runtime::Jobnet,
      :name => "Name",
      :server_name => "Server Name",
      :credential_name => "Credential Name",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1,
      :description => "Description",
      :script => "Script",
      :jobnet_type_cd => 1,
      :executing_pid => "Executing Pid",
      :exit_status => "Exit Status",
      :was_expansion => false,
      :human_phase_name => "タイムアウト強制停止済",
      :stop_reason => "Stop Reason",
      :error_messages => ["foo", "bar"]
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Server Name/)
    rendered.should match(/Credential Name/)
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape("abc,123"))}/)
    rendered.should match(/1/)
    rendered.should match(/Description/)
    rendered.should match(/Script/)
    rendered.should match(/1/)
    rendered.should match(/Executing Pid/)
    rendered.should match(/Exit Status/)
    rendered.should match(/false/)
    rendered.should match(/タイムアウト強制停止済/)
    rendered.should match(/Stop Reason/)
    rendered.should match(/foo/)
    rendered.should match(/bar/)
  end

  it "「一覧に戻る」リンクが表示されていること" do
    render

    rendered.should_not have_link(I18n.t("views.links.back_list"),
      :href => tengine_job_root_jobnet_actuals_path)
  end
end
