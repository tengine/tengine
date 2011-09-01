require 'spec_helper'

describe "tengine/core/events/show.html.erb" do
  before(:each) do
    @event = assign(:event, stub_model(Tengine::Core::Event,
      :event_type_name => "Event Type Name",
      :key => "Key",
      :source_name => "Source Name",
      :notification_level => 1,
      :notification_confirmed => false,
      :sender_name => "Sender Name",
      :properties => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Event Type Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Key/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Source Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Sender Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
