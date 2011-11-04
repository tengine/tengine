require 'spec_helper'

describe "tengine/resource/virtual_servers/show.html.erb" do
  before(:each) do
    @virtual_server = assign(:virtual_server, stub_model(Tengine::Resource::VirtualServer,
      :provider => nil,
      :name => "Name",
      :provided_name => "Provided Name",
      :description => "Description",
      :status => "Status",
      :addresses => {"a"=>"1", "b"=>"2"},
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_id => "Provided Image",
      :provided_type_id => "Provided Type",
      :host_server => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Name/)
    rendered.should match(/Provided Name/)
    rendered.should match(/Description/)
    rendered.should match(/Status/)
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
    rendered.should match(/Provided Image/)
    rendered.should match(/Provided Type/)
    rendered.should match(//)
  end
end
