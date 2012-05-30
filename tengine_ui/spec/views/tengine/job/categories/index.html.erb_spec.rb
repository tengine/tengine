require 'spec_helper'

describe "tengine/job/categories/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:categories, [
      stub_model(Tengine::Job::Category,
        :parent => nil,
        :name => "Name",
        :caption => "Caption"
      ),
      stub_model(Tengine::Job::Category,
        :parent => nil,
        :name => "Name",
        :caption => "Caption"
      )
    ]))
  end

  it "renders a list of tengine_job_categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Caption".to_s, :count => 2
  end
end
