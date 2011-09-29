# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/job/script_actual" do
    name("MyString")
    server_name("MyString")
    credential_name("MyString")
    killing_signals(["abc", "123"])
    killing_signal_interval(1)
    description("MyString")
    script("MyString")
    executing_pid("MyString")
    exit_status("MyString")
    phase_cd(1)
    started_at("2011-09-29 09:55:32")
    finished_at("2011-09-29 09:55:32")
    stopped_at("2011-09-29 09:55:32")
    stop_reason("MyString")
  end
end
