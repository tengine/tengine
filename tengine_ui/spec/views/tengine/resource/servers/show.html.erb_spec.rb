require 'spec_helper'

describe "tengine/resource/servers/show.html.erb" do
  before(:each) do
    @server = assign(:server, stub_model(Tengine::Resource::Server,{
      :provider => stub_model(Tengine::Resource::Provider, :name => "EC2 test account"),
      :name => "Name",
      :provided_id => "Provided Name",
      :description => "Description",
      :status => "Status",
      :addresses => {"a"=>"1", "b"=>"2"},
      :properties => {"a"=>"1", "b"=>"2"}
    }))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/EC2 test account/)
    rendered.should match(/Name/)
    rendered.should match(/Provided Name/)
    rendered.should match(/Description/)
    rendered.should match(/Status/)
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
  end
end
