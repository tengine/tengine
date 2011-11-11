require 'spec_helper'

describe "tengine/job/executions/new.html.erb" do
  before(:each) do
    assign(:execution, stub_model(Tengine::Job::Execution,
      :root_jobnet => nil,
      :target_actual_ids => ["abc", "123"],
      :phase_cd => 1,
      :preparation_command => "MyString",
      :actual_base_timeout_alert => 1,
      :actual_base_timeout_termination => 1,
      :estimated_time => 1,
      :keeping_stdout => false,
      :keeping_stderr => false
    ).as_new_record)
    assign(:target_actual_class, Tengine::Job::RootJobnetTemplate)
    assign(:target_actuals, [
      stub_model(Tengine::Job::RootJobnetTemplate,
        :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
        :name => "Name",
        :description => "Description",
        :script => "Script",
        :dsl_filepath => "Dsl Filepath",
      ),
      stub_model(Tengine::Job::RootJobnetTemplate,
        :id => BSON::ObjectId("4e955633c3406b3a9f000001"),
        :name => "Name",
        :description => "Description",
        :script => "Script",
        :dsl_filepath => "Dsl Filepath",
      )
    ])
  end

  it "renders new execution form" do
    render

    rendered.should have_xpath("//input[@id='execution_preparation_command'][@type='text']")
    rendered.should have_xpath("//input[@id='execution_actual_base_timeout_alert'][@type='number']")
    rendered.should have_xpath("//input[@id='execution_actual_base_timeout_termination'][@type='number']")
    rendered.should have_xpath("//input[@id='execution_retry'][@type='hidden']")
    rendered.should have_xpath("//input[@id='execution_target_actual_ids'][@type='hidden']")
  end
end
