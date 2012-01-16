require 'spec_helper'

describe "tengine/test/sshes/show.html.erb" do
  before(:each) do
    @ssh = assign(:ssh, stub_model(Tengine::Test::Ssh,
      :host => "Host",
      :exec_type => "Exec Type",
      :user => "User",
      :options => {"a"=>"1", "b"=>"2"},
      :timeout => 1,
      :command => "Command",
      :stdout => "Stdout",
      :stderr => "Stderr",
      :error_message => "Error Message"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Host/)
    rendered.should match(/Exec Type/)
    rendered.should match(/User/)
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
    rendered.should match(/1/)
    rendered.should match(/Command/)
    rendered.should match(/Stdout/)
    rendered.should match(/Stderr/)
    rendered.should match(/Error Message/)
  end
end
