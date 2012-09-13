require 'spec_helper'

describe "tengine/resource/physical_servers/show.html.erb" do
=begin
#画面を利用しないのでコメントしています。
  before(:each) do
    @physical_server = assign(:physical_server, stub_model(Tengine::Resource::PhysicalServer,
      :provider => nil,
      :name => "Name",
      :provided_id => "Provided Name",
      :description => "Description",
      :status => "Status",
      :addresses => {"a"=>"1", "b"=>"2"},
      :properties => {"a"=>"1", "b"=>"2"}
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
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
    rendered.should match(/#{Regexp.escape(ERB::Util.html_escape(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
  end
=end
end
