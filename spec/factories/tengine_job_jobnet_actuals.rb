# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/job/jobnet_actual" do
    name("MyString")
    server_name("MyString")
    credential_name("MyString")
    killing_signals(["abc", "123"])
    killing_signal_interval(1)
    description("MyString")
    dsl_version("MyString")
    lock_version(1)
    was_expansion(false)
    phase_cd(1)
    started_at("2011-09-27 18:59:54")
    finished_at("2011-09-27 18:59:54")
    stopped_at("2011-09-27 18:59:54")
    stop_reason("MyString")
  end
end
