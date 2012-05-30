require 'spec_helper'

describe "tengine/resource/providers/new.html.erb" do
  before(:each) do
    assign(:provider, stub_model(Tengine::Resource::Provider,
      :name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new provider form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_providers_path, :method => "post" do
      assert_select "input#provider_name", :name => "provider[name]"
      assert_select "input#provider_description", :name => "provider[description]"
    end
  end
end
