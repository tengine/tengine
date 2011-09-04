require 'spec_helper'

describe "tengine/core/sessions/new.html.erb" do
  before(:each) do
    assign(:session, stub_model(Tengine::Core::Session,
      :properties => {"a"=>"1", "b"=>"2"}
    ).as_new_record)
  end

  it "renders new session form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_sessions_path, :method => "post" do
      assert_select "textarea#session_properties_yaml", :name => "session[properties_yaml]"
    end
  end
end
