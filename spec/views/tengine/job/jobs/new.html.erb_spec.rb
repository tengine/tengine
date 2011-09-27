require 'spec_helper'

describe "tengine/job/jobs/new.html.erb" do
  before(:each) do
    assign(:job, stub_model(Tengine::Job::Job,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1
    ).as_new_record)
  end

  it "renders new job form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_jobs_path, :method => "post" do
      assert_select "input#job_name", :name => "job[name]"
      assert_select "input#job_server_name", :name => "job[server_name]"
      assert_select "input#job_credential_name", :name => "job[credential_name]"
      assert_select "input#job_killing_signals_text", :name => "job[killing_signals_text]"
      assert_select "input#job_killing_signal_interval", :name => "job[killing_signal_interval]"
    end
  end
end
