require 'spec_helper'

describe "tengine/core/sessions/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:sessions, [
      stub_model(Tengine::Core::Session,
        :properties => {"a"=>"1", "b"=>"2"}
      ),
      stub_model(Tengine::Core::Session,
        :properties => {"a"=>"1", "b"=>"2"}
      )
    ]))
  end

  it "renders a list of tengine_core_sessions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
  end
end
