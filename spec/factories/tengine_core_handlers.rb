# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/core/handler" do
    event_type_names(["abc", "123"])
  end
end
