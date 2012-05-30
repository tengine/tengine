require 'spec_helper'

describe "tengine/job/edges/show.html.erb" do
  before(:each) do
    @edge = assign(:edge, stub_model(Tengine::Job::Edge,
      :phase_cd => 1,
      :origin_id => BSON::ObjectId.new,
      :destination_id => BSON::ObjectId.new
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Origin/)
    rendered.should match(/Destination/)
  end
end
