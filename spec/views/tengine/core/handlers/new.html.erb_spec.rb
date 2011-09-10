require 'spec_helper'

describe "tengine/core/handlers/new.html.erb" do
  before(:each) do
    @driver = assign(:driver, stub_model(Tengine::Core::Driver,
      :name => "driver1", :version => "1234"
    ))
    @handler = assign(:handler, stub_model(Tengine::Core::Handler,
      :event_type_names => ["abc", "123"],
      :filter => {"a"=>"1", "b"=>"2"}
    ).as_new_record)
  end

  it "renders new handler form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_driver_handlers_path(@driver), :method => "post" do
      assert_select "textarea#handler_event_type_names_text", :name => "handler[event_type_names_text]"
      assert_select "textarea#handler_filter_yaml", :name => "handler[filter_yaml]"
    end
  end
end
