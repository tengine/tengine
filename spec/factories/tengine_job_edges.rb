# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/job/edge" do
    status_cd(1)
    origin_id("MyString")
    destination_id("MyString")
  end
end
