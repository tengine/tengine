require 'spec_helper'

describe "tengine/resource/servers/show.html.erb" do
  before(:each) do
    @server = assign(:server, stub_model(Tengine::Resource::Server, {
      :name => "Name",
      :description => "Description",
      # :host => nil,
      :provided_name => "Provided Name",
      :status => "Status",
      :public_hostname => "Public Hostname",
      :public_ipv4 => "Public Ipv4",
      :local_hostname => "Local Hostname",
      :local_ipv4 => "Local Ipv4",
      :properties => {"a"=>"1", "b"=>"2"},
      # :provided_image_name => "Provided Image Name"
    }))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/Description/)
    # rendered.should match(//)
    rendered.should match(/Provided Name/)
    rendered.should match(/Status/)
    rendered.should match(/Public Hostname/)
    rendered.should match(/Public Ipv4/)
    rendered.should match(/Local Hostname/)
    rendered.should match(/Local Ipv4/)
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
    # rendered.should match(/Provided Image Name/)
  end
end
