require 'spec_helper'

describe "tengine/core/events/edit.html.erb" do
  before(:each) do
    @event = assign(:event, stub_model(Tengine::Core::Event,
      :event_type_name => "MyString",
      :key => "MyString",
      :source_name => "MyString",
      :level => 1,
      :confirmed => false,
      :sender_name => "MyString",
      :properties => {"a"=>"1", "b"=>"2"}
    ))
  end

  it "renders the edit event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_events_path(@event), :method => "post" do
      assert_select "input#event_event_type_name", :name => "event[event_type_name]"
      assert_select "input#event_key", :name => "event[key]"
      assert_select "input#event_source_name", :name => "event[source_name]"
      assert_select "input#event_level", :name => "event[level]"
      assert_select "input#event_confirmed", :name => "event[confirmed]"
      assert_select "input#event_sender_name", :name => "event[sender_name]"
      assert_select "textarea#event_properties_yaml", :name => "event[properties_yaml]"
    end
  end
end
