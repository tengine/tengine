# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/test/ssh" do
    host("MyString")
    user("MyString")
    options({"a"=>"1", "b"=>"2"})
    command("MyString")
    timeout(1)
    stdout("MyString")
    stderr("MyString")
    error_message("MyString")
  end
end
