require 'spec_helper'

describe "tengine/core/sessions/show.html.erb" do
  before(:each) do
    @session = assign(:session, stub_model(Tengine::Core::Session,
      :lock_version => 1,
      :properties => {"a"=>"1", "b"=>"2"},
      :system_properties => {"a"=>"1", "b"=>"2"}
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
  end
end
