require 'spec_helper'

describe "tengine/core/events/new.html.erb" do
  before(:each) do
    assign(:event, stub_model(Tengine::Core::Event,
      :event_type_name => "MyString",
      :key => "MyString",
      :source_name => "MyString",
      :notification_level => 1,
      :notification_confirmed => false,
      :sender_name => "MyString",
      :properties => ""
    ).as_new_record)
  end

  it "renders new event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_events_path, :method => "post" do
      assert_select "input#event_event_type_name", :name => "event[event_type_name]"
      assert_select "input#event_key", :name => "event[key]"
      assert_select "input#event_source_name", :name => "event[source_name]"
      assert_select "input#event_notification_level", :name => "event[notification_level]"
      assert_select "input#event_notification_confirmed", :name => "event[notification_confirmed]"
      assert_select "input#event_sender_name", :name => "event[sender_name]"
      assert_select "input#event_properties", :name => "event[properties]"
    end
  end
end
