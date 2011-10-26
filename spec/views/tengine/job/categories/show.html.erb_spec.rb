require 'spec_helper'

describe "tengine/job/categories/show.html.erb" do
  before(:each) do
    @category = assign(:category, stub_model(Tengine::Job::Category,
      :parent => nil,
      :name => "Name",
      :caption => "Caption"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Name/)
    rendered.should match(/Caption/)
  end
end
