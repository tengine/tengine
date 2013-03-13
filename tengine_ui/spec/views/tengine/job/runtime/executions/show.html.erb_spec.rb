require 'spec_helper'

describe "tengine/job/runtime/executions/show.html.erb" do
  before(:each) do
    @execution = assign(:execution, stub_model(Tengine::Job::Runtime::Execution,
      :root_jobnet => nil,
      :target_actual_ids => ["abc", "123"],
      :phase_cd => 1,
      :preparation_command => "Preparation Command",
      :actual_base_timeout_alert => 1,
      :actual_base_timeout_termination => 1,
      :estimated_time => 1,
      :keeping_stdout => false,
      :keeping_stderr => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape("abc,123"))}/)
    rendered.should match(/1/)
    rendered.should match(/Preparation Command/)
    rendered.should match(/1/)
    rendered.should match(/1/)
    rendered.should match(/1/)
    rendered.should match(/false/)
    rendered.should match(/false/)
  end
end
