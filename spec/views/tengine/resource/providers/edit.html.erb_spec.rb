require 'spec_helper'

describe "tengine/resource/providers/edit.html.erb" do
  before(:each) do
    @provider = assign(:provider, stub_model(Tengine::Resource::Provider,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit provider form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_providers_path(@provider), :method => "post" do
      assert_select "input#provider_name", :name => "provider[name]"
      assert_select "input#provider_description", :name => "provider[description]"
    end
  end
end
