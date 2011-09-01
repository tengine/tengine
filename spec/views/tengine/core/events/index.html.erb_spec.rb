require 'spec_helper'

describe "tengine/core/events/index.html.erb" do
  before(:each) do
    assign(:events, [
      stub_model(Tengine::Core::Event,
        :event_type_name => "Event Type Name",
        :key => "Key",
        :source_name => "Source Name",
        :notification_level => 1,
        :notification_confirmed => false,
        :sender_name => "Sender Name",
        :properties => "properties YAML"
      ),
      stub_model(Tengine::Core::Event,
        :event_type_name => "Event Type Name",
        :key => "Key",
        :source_name => "Source Name",
        :notification_level => 1,
        :notification_confirmed => false,
        :sender_name => "Sender Name",
        :properties => "properties YAML"
      )
    ])
  end

  it "renders a list of tengine_core_events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Event Type Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Source Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Sender Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "properties YAML".to_s, :count => 2
  end
end
