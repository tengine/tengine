require 'spec_helper'

describe "tengine/resource/provider/ec2s/edit.html.erb" do
  before(:each) do
    @ec2 = assign(:ec2, stub_model(Tengine::Resource::Provider::Ec2,
      :name => "MyString",
      :description => "MyString",
      :credential => nil
    ))
  end

  it "renders the edit ec2 form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_provider_ec2s_path(@ec2), :method => "post" do
      assert_select "input#ec2_name", :name => "ec2[name]"
      assert_select "input#ec2_description", :name => "ec2[description]"
      assert_select "input#ec2_credential_id", :name => "ec2[credential_id]"
    end
  end
end
