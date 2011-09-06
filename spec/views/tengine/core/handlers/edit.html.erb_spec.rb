require 'spec_helper'

describe "tengine/core/handlers/edit.html.erb" do
  before(:each) do
    @driver = assign(:driver, stub_model(Tengine::Core::Driver,
      :name => "driver1", :version => "1234"
    ))
    @handler = assign(:handler, stub_model(Tengine::Core::Handler,
      :event_type_names => ["abc", "123"]
    ))
  end

  it "renders the edit handler form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_driver_handlers_path(@driver, @handler), :method => "post" do
      assert_select "textarea#handler_event_type_names_text", :name => "handler[event_type_names_text]"
    end
  end
end
