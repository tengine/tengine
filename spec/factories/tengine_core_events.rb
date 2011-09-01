# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/core/event" do
    event_type_name("MyString")
    key("MyString")
    source_name("MyString")
    occurred_at("2011-09-01 17:16:21")
    notification_level(1)
    notification_confirmed(false)
    sender_name("MyString")
    properties({"a"=>"1", "b"=>"2"})
  end
end
