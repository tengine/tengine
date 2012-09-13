require 'spec_helper'

describe "tengine/test/scripts/show.html.erb" do
  before(:each) do
    @script = assign(:script, stub_model(Tengine::Test::Script,
      :kind => "Kind",
      :code => "Code",
      :options => {"a"=>"1", "b"=>"2"},
      :timeout => 1,
      :messages => {"a"=>"1", "b"=>"2"}
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Kind/)
    rendered.should match(/Code/)
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
    rendered.should match(/1/)
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
  end
end
