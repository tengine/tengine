# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/job/jobnet_actual" do
    name("MyString")
    server_name("MyString")
    credential_name("MyString")
    killing_signals(["abc", "123"])
    killing_signal_interval(1)
    description("MyString")
    script("MyString")
    jobnet_type_cd(1)
    executing_pid("MyString")
    exit_status("MyString")
    was_expansion(false)
    phase_cd(1)
    started_at("2011-10-12 13:01:46")
    finished_at("2011-10-12 13:01:46")
    stopped_at("2011-10-12 13:01:46")
    stop_reason("MyString")
  end
end
