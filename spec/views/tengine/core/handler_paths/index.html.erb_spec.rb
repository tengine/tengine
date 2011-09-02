require 'spec_helper'

describe "tengine/core/handler_paths/index.html.erb" do
  before(:each) do
    assign(:handler_paths, [
      stub_model(Tengine::Core::HandlerPath,
        :event_type_name => "Event Type Name",
        :driver => nil,
        :handler_id => ""
      ),
      stub_model(Tengine::Core::HandlerPath,
        :event_type_name => "Event Type Name",
        :driver => nil,
        :handler_id => ""
      )
    ])
  end

  it "renders a list of tengine_core_handler_paths" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Event Type Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
