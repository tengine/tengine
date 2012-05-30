# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/job/execution" do
    root_jobnet(nil)
    target_actual_ids(["abc", "123"])
    phase_cd(1)
    started_at("2011-10-11 23:22:56")
    finished_at("2011-10-11 23:22:56")
    preparation_command("MyString")
    actual_base_timeout_alert(1)
    actual_base_timeout_termination(1)
    estimated_time(1)
    keeping_stdout(false)
    keeping_stderr(false)
  end
end
