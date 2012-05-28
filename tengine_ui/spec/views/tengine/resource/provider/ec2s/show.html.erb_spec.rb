require 'spec_helper'

describe "tengine/resource/provider/ec2s/show.html.erb" do
  before(:each) do
    @ec2 = assign(:ec2, stub_model(Tengine::ResourceEc2::Provider,
      :name => "Name",
      :description => "Description",
      :credential => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
