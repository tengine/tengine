require 'spec_helper'

describe "tengine/core/handler_paths/index.html.erb" do
  before(:each) do
    @driver = assign(:driver, stub_model(Tengine::Core::Driver,
      :name => "driver1", :version => "1234"
    ))
    assign(:handler_paths, [
      stub_model(Tengine::Core::HandlerPath,
        :event_type_name => "Event Type Name",
        :driver => @driver,
        :handler_id => "handler1"
      ),
      stub_model(Tengine::Core::HandlerPath,
        :event_type_name => "Event Type Name",
        :driver => @driver,
        :handler_id => "handler2"
      )
    ])
  end

  it "renders a list of tengine_core_handler_paths" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Event Type Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "driver1".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "handler1".to_s, :count => 1
    assert_select "tr>td", :text => "handler2".to_s, :count => 1
  end
end
