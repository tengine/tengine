require 'spec_helper'

describe "tengine/test/scripts/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:scripts, [
      stub_model(Tengine::Test::Script,
        :code => "Code",
        :result => "Result",
        :message => "Message"
      ),
      stub_model(Tengine::Test::Script,
        :code => "Code",
        :result => "Result",
        :message => "Message"
      )
    ]))
  end

  it "renders a list of tengine_test_scripts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Result".to_s, :count => 2
    assert_select "tr>td", :text => "Message".to_s, :count => 2
  end
end
