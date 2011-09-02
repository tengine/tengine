require 'spec_helper'

describe "tengine/core/handler_paths/new.html.erb" do
  before(:each) do
    assign(:handler_path, stub_model(Tengine::Core::HandlerPath,
      :event_type_name => "MyString",
      :driver => nil,
      :handler_id => ""
    ).as_new_record)
  end

  it "renders new handler_path form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_handler_paths_path, :method => "post" do
      assert_select "input#handler_path_event_type_name", :name => "handler_path[event_type_name]"
      assert_select "input#handler_path_driver_id", :name => "handler_path[driver_id]"
      assert_select "input#handler_path_handler_id", :name => "handler_path[handler_id]"
    end
  end
end
