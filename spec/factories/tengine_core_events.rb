# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/core/event" do
    event_type_name "MyString"
    key "MyString"
    source_name "MyString"
    occurred_at "2011-09-01 16:14:37"
    notification_level 1
    notification_confirmed false
    sender_name "MyString"
    properties ""
  end
end
