# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/resource/virtual_server" do
    provider(nil)
    name("MyString")
    provided_id("MyString")
    description("MyString")
    status("MyString")
    addresses({"a"=>"1", "b"=>"2"})
    properties({"a"=>"1", "b"=>"2"})
    provided_image_id("MyString")
    provided_type_id("MyString")
    host_server("")
  end
end
