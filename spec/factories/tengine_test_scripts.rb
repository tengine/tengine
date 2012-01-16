# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/test/script" do
    code("MyString")
    result("MyString")
    message("MyString")
  end
end
