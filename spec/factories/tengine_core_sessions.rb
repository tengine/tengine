# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/core/session" do
    properties({"a"=>"1", "b"=>"2"})
  end
end
