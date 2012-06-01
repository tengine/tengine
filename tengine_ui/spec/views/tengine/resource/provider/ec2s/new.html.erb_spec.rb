require 'spec_helper'

describe "tengine/resource/provider/ec2s/new.html.erb" do
  before(:each) do
    assign(:ec2, stub_model(Tengine::ResourceEc2::Provider,
      :name => "MyString",
      :description => "MyString",
      :connection_settings => nil
    ).as_new_record)
  end

  it "renders new ec2 form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_provider_ec2s_path, :method => "post" do
      assert_select "input#ec2_name", :name => "ec2[name]"
      assert_select "input#ec2_description", :name => "ec2[description]"
      assert_select "textarea#ec2_connection_settings", :name => "ec2[connection_settings]"
    end
  end
end
