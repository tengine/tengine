# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/resource_ec2/provider" do
    name("MyString")
    description("MyString")
    credential(nil)
  end
end
