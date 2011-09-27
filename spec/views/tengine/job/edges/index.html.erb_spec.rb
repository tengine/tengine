require 'spec_helper'

describe "tengine/job/edges/index.html.erb" do
  before(:each) do
    @id1 = BSON::ObjectId.new
    @id2 = BSON::ObjectId.new
    mock_pagination(assign(:edges, [
      stub_model(Tengine::Job::Edge,
        :status_cd => 1,
        :origin_id => @id1,
        :destination_id => @id2,
      ),
      stub_model(Tengine::Job::Edge,
        :status_cd => 1,
        :origin_id => @id1,
        :destination_id => @id2,
      )
    ]))
  end

  it "renders a list of tengine_job_edges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => @id1.to_s, :count => 2
    assert_select "tr>td", :text => @id2.to_s, :count => 2
  end
end
