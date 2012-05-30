require 'spec_helper'

describe "tengine/job/categories/edit.html.erb" do
  before(:each) do
    @category = assign(:category, stub_model(Tengine::Job::Category,
      :parent => nil,
      :name => "MyString",
      :caption => "MyString"
    ))
  end

  it "renders the edit category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_categories_path(@category), :method => "post" do
      assert_select "input#category_parent_id", :name => "category[parent_id]"
      assert_select "input#category_name", :name => "category[name]"
      assert_select "input#category_caption", :name => "category[caption]"
    end
  end
end
