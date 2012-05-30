# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/resource/credential" do
    name("MyString")
    description("MyString")
    auth_type_cd("MyString")
    auth_values({"a"=>"1", "b"=>"2"})
  end
end
