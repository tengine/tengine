require 'spec_helper'

describe "tengine/resource/physical_servers/show.html.erb" do
  before(:each) do
    @physical_server = assign(:physical_server, stub_model(Tengine::Resource::PhysicalServer,
      :provider => nil,
      :name => "Name",
      :description => "Description",
      :provided_name => "Provided Name",
      :status => "Status",
      :public_hostname => "Public Hostname",
      :public_ipv4 => "Public Ipv4",
      :local_hostname => "Local Hostname",
      :local_ipv4 => "Local Ipv4",
      :properties => {"a"=>"1", "b"=>"2"}
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Provided Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Status/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Public Hostname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Public Ipv4/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Local Hostname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Local Ipv4/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
  end
end
