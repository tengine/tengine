require 'spec_helper'

describe "tengine/resource/providers/show.html.erb" do
  before(:each) do
    @provider = assign(:provider, stub_model(Tengine::Resource::Provider,
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
  end
end
