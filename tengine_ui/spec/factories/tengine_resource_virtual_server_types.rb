# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/resource/virtual_server_type" do
    provider(nil)
    provided_id("MyString")
    properties({"a"=>"1", "b"=>"2"})
    caption("MyString")
  end
end
