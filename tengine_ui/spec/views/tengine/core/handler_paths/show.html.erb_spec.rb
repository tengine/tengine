require 'spec_helper'

describe "tengine/core/handler_paths/show.html.erb" do
  before(:each) do
    @handler_path = assign(:handler_path, stub_model(Tengine::Core::HandlerPath,
      :event_type_name => "Event Type Name",
      :driver => nil,
      :handler_id => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Event Type Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
