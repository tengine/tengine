require 'spec_helper'

describe "tengine/job/categories/new.html.erb" do
  before(:each) do
    assign(:category, stub_model(Tengine::Job::Category,
      :parent => nil,
      :name => "MyString",
      :caption => "MyString"
    ).as_new_record)
  end

  it "renders new category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_categories_path, :method => "post" do
      assert_select "input#category_parent_id", :name => "category[parent_id]"
      assert_select "input#category_name", :name => "category[name]"
      assert_select "input#category_caption", :name => "category[caption]"
    end
  end
end
