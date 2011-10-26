require 'spec_helper'

describe "tengine/resource/credentials/new.html.erb" do
  before(:each) do
    assign(:credential, stub_model(Tengine::Resource::Credential,
      :name => "MyString",
      :description => "MyString",
      :auth_type_cd => "MyString",
      :auth_values => {"a"=>"1", "b"=>"2"}
    ).as_new_record)
  end

  it "renders new credential form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_credentials_path, :method => "post" do
      assert_select "input#credential_name", :name => "credential[name]"
      assert_select "input#credential_description", :name => "credential[description]"
      assert_select "select#credential_auth_type_cd", :name => "credential[auth_type_cd]"
      assert_select "textarea#credential_auth_values_yaml", :name => "credential[auth_values_yaml]"
    end
  end
end
