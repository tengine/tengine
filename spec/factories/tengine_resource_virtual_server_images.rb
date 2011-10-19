# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/resource/virtual_server_image" do
    provider(nil)
    name("MyString")
    description("MyString")
    provided_name("MyString")
  end
end
