require 'spec_helper'

describe "tengine/test/sshes/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:sshes, [
      stub_model(Tengine::Test::Ssh,
        :host => "Host",
        :user => "User",
        :options => {"a"=>"1", "b"=>"2"},
        :command => "Command",
        :timeout => 1,
        :stdout => "Stdout",
        :stderr => "Stderr",
        :error_message => "Error Message"
      ),
      stub_model(Tengine::Test::Ssh,
        :host => "Host",
        :user => "User",
        :options => {"a"=>"1", "b"=>"2"},
        :command => "Command",
        :timeout => 1,
        :stdout => "Stdout",
        :stderr => "Stderr",
        :error_message => "Error Message"
      )
    ]))
  end

  it "renders a list of tengine_test_sshes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Host".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
    assert_select "tr>td", :text => "Command".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Stdout".to_s, :count => 2
    assert_select "tr>td", :text => "Stderr".to_s, :count => 2
    assert_select "tr>td", :text => "Error Message".to_s, :count => 2
  end
end
