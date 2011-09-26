require 'spec_helper'

describe "tengine/resource/providers/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:providers, [
      stub_model(Tengine::Resource::Provider,
        :name => "Name",
        :description => "Description"
      ),
      stub_model(Tengine::Resource::Provider,
        :name => "Name",
        :description => "Description"
      )
    ]))
  end

  it "renders a list of tengine_resource_providers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
