require 'spec_helper'

describe "tengine/resource/credentials/show.html.erb" do
  before(:each) do
    @credential = assign(:credential, stub_model(Tengine::Resource::Credential,
      :name => "Name",
      :description => "Description",
      :auth_type_cd => "Auth Type Cd",
      :auth_values => {"a"=>"1", "b"=>"2"}
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Auth Type Cd/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"a"=>"1", "b"=>"2"})))}/)
  end
end
