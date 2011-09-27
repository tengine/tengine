# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/job/script_actual" do
    name("MyString")
    server_name("MyString")
    credential_name("MyString")
    killing_signals(["abc", "123"])
    killing_signal_interval(1)
    script("MyString")
    has_chained_children(false)
    executing_pid("MyString")
    exit_status("MyString")
    phase_cd(1)
    started_at("2011-09-27 19:00:11")
    finished_at("2011-09-27 19:00:11")
    stopped_at("2011-09-27 19:00:11")
    stop_reason("MyString")
  end
end
