require 'spec_helper'

describe "tengine/core/handlers/edit.html.erb" do
  before(:each) do
    @handler = assign(:handler, stub_model(Tengine::Core::Handler,
      :event_type_names => ["abc", "123"]
    ))
  end

  it "renders the edit handler form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_handlers_path(@handler), :method => "post" do
      assert_select "input#handler_event_type_names_text", :name => "handler[event_type_names_text]"
    end
  end
end
