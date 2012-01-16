require 'spec_helper'

describe "tengine/test/scripts/show.html.erb" do
  before(:each) do
    @script = assign(:script, stub_model(Tengine::Test::Script,
      :code => "Code",
      :result => "Result",
      :message => "Message"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Code/)
    rendered.should match(/Result/)
    rendered.should match(/Message/)
  end
end
