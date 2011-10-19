require 'spec_helper'

describe "tengine/resource/credentials/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:credentials, [
      stub_model(Tengine::Resource::Credential,
        :name => "Name",
        :description => "Description",
        :auth_type_cd => "Auth Type Cd",
        :auth_values => {"a"=>"1", "b"=>"2"}
      ),
      stub_model(Tengine::Resource::Credential,
        :name => "Name",
        :description => "Description",
        :auth_type_cd => "Auth Type Cd",
        :auth_values => {"a"=>"1", "b"=>"2"}
      )
    ]))
  end

  it "renders a list of tengine_resource_credentials" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Auth Type Cd".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})), :count => 2
  end
end
