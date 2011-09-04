require 'spec_helper'

describe "tengine/core/sessions/edit.html.erb" do
  before(:each) do
    @session = assign(:session, stub_model(Tengine::Core::Session,
      :properties => {"a"=>"1", "b"=>"2"}
    ))
  end

  it "renders the edit session form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_sessions_path(@session), :method => "post" do
      assert_select "textarea#session_properties_yaml", :name => "session[properties_yaml]"
    end
  end
end
