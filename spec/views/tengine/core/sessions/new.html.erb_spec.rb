require 'spec_helper'

describe "tengine/core/sessions/new.html.erb" do
  before(:each) do
    assign(:session, stub_model(Tengine::Core::Session,
      :lock_version => 1,
      :properties => {"a"=>"1", "b"=>"2"},
      :system_properties => {"a"=>"1", "b"=>"2"}
    ).as_new_record)
  end

  it "renders new session form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_sessions_path, :method => "post" do
      assert_select "input#session_lock_version", :name => "session[lock_version]"
      assert_select "textarea#session_properties_yaml", :name => "session[properties_yaml]"
      assert_select "textarea#session_system_properties_yaml", :name => "session[system_properties_yaml]"
    end
  end
end
