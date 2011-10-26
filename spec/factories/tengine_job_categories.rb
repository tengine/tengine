# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/job/category" do
    parent(nil)
    name("MyString")
    caption("MyString")
  end
end
