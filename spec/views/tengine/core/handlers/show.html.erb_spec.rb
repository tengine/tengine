require 'spec_helper'

describe "tengine/core/handlers/show.html.erb" do
  before(:each) do
    @handler = assign(:handler, stub_model(Tengine::Core::Handler,
      :event_type_names => ["abc", "123"]
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML("abc,123"))}/)
  end
end
