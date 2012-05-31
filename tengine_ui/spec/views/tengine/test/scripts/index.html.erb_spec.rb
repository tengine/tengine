require 'spec_helper'

describe "tengine/test/scripts/index.html.erb" do
  before(:each) do
    scripts = [
      stub_model(Tengine::Test::Script,
        :kind => "01",
        :code => "Code",
        :options => {"a"=>"1", "b"=>"2"},
        :timeout => 1,
        :messages => {"x"=>"1", "y"=>"2"}
      ),
      stub_model(Tengine::Test::Script,
        :kind => "01",
        :code => "Code",
        :options => {"a"=>"1", "b"=>"2"},
        :timeout => 1,
        :messages => {"x"=>"1", "y"=>"2"}
      )
    ]
    assign :script, scripts[0]
    mock_pagination(assign(:scripts, scripts))
  end

  it "renders a list of tengine_test_scripts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "eval".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"x"=>"1", "y"=>"2"})), :count => 2
  end
end
