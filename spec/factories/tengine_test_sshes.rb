# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/test/ssh" do
    host("MyString")
    exec_type("MyString")
    user("MyString")
    options({"a"=>"1", "b"=>"2"})
    timeout(1)
    command("MyString")
    stdout("MyString")
    stderr("MyString")
    error_message("MyString")
  end
end
