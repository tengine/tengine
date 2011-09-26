# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :"tengine/resource/physical_server" do
    provider(nil)
    name("MyString")
    description("MyString")
    provided_name("MyString")
    status("MyString")
    public_hostname("MyString")
    public_ipv4("MyString")
    local_hostname("MyString")
    local_ipv4("MyString")
    properties({"a"=>"1", "b"=>"2"})
  end
end
