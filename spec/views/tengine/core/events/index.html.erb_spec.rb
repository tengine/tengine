require 'spec_helper'

describe "tengine/core/events/index.html.erb" do
  before(:each) do
    assign(:finder, Tengine::Core::Event::Finder.new)
    mock_pagination(assign(:events, [
      stub_model(Tengine::Core::Event,
        :event_type_name => "Event Type Name",
        :key => "Key",
        :source_name => "Source Name",
        :level => 1,
        :confirmed => false,
        :sender_name => "Sender Name",
        :properties => {"a"=>"1", "b"=>"2"}
      ),
      stub_model(Tengine::Core::Event,
        :event_type_name => "Event Type Name",
        :key => "Key",
        :source_name => "Source Name",
        :level => 1,
        :confirmed => false,
        :sender_name => "Sender Name",
        :properties => {"a"=>"1", "b"=>"2"}
      )
    ]))
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
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
  end
end
