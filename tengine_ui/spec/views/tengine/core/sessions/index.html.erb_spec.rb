require 'spec_helper'

describe "tengine/core/sessions/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:sessions, [
      stub_model(Tengine::Core::Session,
        :lock_version => 1,
        :properties => {"a"=>"1", "b"=>"2"},
        :system_properties => {"c"=>"1", "d"=>"2"}
      ),
      stub_model(Tengine::Core::Session,
        :lock_version => 1,
        :properties => {"a"=>"1", "b"=>"2"},
        :system_properties => {"c"=>"1", "d"=>"2"}
      )
    ]))
  end

  it "renders a list of tengine_core_sessions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"c"=>"1", "d"=>"2"})), :count => 2
  end
end
