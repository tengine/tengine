# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/job/root_jobnet_actual" do
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
    started_at("2011-10-12 13:02:44")
    finished_at("2011-10-12 13:02:44")
    stopped_at("2011-10-12 13:02:44")
    stop_reason("MyString")
    category(nil)
    lock_version(1)
    template(nil)
  end
end
