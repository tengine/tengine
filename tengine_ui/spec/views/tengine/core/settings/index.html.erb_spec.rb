require 'spec_helper'

describe "tengine/core/settings/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:settings, [
      stub_model(Tengine::Core::Setting,
        :name => "Name",
        :value => "Value"
      ),
      stub_model(Tengine::Core::Setting,
        :name => "Name",
        :value => "Value"
      )
    ]))
  end

  it "renders a list of tengine_core_settings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
