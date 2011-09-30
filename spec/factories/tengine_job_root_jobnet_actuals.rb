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
    was_expansion(false)
    phase_cd(1)
    started_at("2011-09-30 17:30:30")
    finished_at("2011-09-30 17:30:30")
    stopped_at("2011-09-30 17:30:30")
    stop_reason("MyString")
    category(nil)
    lock_version(1)
    template(nil)
  end
end
