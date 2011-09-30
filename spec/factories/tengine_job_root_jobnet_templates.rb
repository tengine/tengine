# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/job/root_jobnet_template" do
    name("MyString")
    server_name("MyString")
    credential_name("MyString")
    killing_signals(["abc", "123"])
    killing_signal_interval(1)
    description("MyString")
    script("MyString")
    jobnet_type_cd(1)
    category(nil)
    dsl_filepath("MyString")
    dsl_lineno(1)
    dsl_version("MyString")
    lock_version(1)
  end
end
