require 'spec_helper'

describe "tengine/resource/virtual_server_types/show.html.erb" do
  before(:each) do
    @virtual_server_type = assign(:virtual_server_type, stub_model(Tengine::Resource::VirtualServerType,
      :provider => nil,
      :provided_id => "Provided",
      :properties => {"a"=>"1", "b"=>"2"},
      :caption => "Caption"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Provided/)
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
    rendered.should match(/Caption/)
  end
end
