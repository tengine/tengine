# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/test/script" do
    kind("MyString")
    code("MyString")
    options({"a"=>"1", "b"=>"2"})
    timeout(1)
    messages({"a"=>"1", "b"=>"2"})
  end
end
