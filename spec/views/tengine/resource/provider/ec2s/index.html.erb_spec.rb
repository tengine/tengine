require 'spec_helper'

describe "tengine/resource/provider/ec2s/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:ec2s, [
      stub_model(Tengine::Resource::Provider::Ec2,
        :name => "Name",
        :description => "Description",
        :credential => nil
      ),
      stub_model(Tengine::Resource::Provider::Ec2,
        :name => "Name",
        :description => "Description",
        :credential => nil
      )
    ]))
  end

  it "renders a list of tengine_resource_provider_ec2s" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
