require 'spec_helper'

describe "tengine/resource/virtual_server_types/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:virtual_server_types, [
      stub_model(Tengine::Resource::VirtualServerType,
        :provider => nil,
        :provided_id => "Provided",
        :properties => {"a"=>"1", "b"=>"2"},
        :caption => "Caption"
      ),
      stub_model(Tengine::Resource::VirtualServerType,
        :provider => nil,
        :provided_id => "Provided",
        :properties => {"a"=>"1", "b"=>"2"},
        :caption => "Caption"
      )
    ]))
  end

  it "renders a list of tengine_resource_virtual_server_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Provided".to_s, :count => 2
    assert_select "tr>td>pre", :text => ERB::Util.html_escape(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
    assert_select "tr>td", :text => "Caption".to_s, :count => 2
  end
end
