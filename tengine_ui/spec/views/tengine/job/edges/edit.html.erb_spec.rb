require 'spec_helper'

describe "tengine/job/edges/edit.html.erb" do
  before(:each) do
    @edge = assign(:edge, stub_model(Tengine::Job::Edge,
      :phase_cd => 1,
      :origin_id => BSON::ObjectId.new,
      :destination_id => BSON::ObjectId.new
    ))
  end

  it "renders the edit edge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_edges_path(@edge), :method => "post" do
      assert_select "input#edge_phase_cd", :name => "edge[phase_cd]"
      assert_select "input#edge_origin_id", :name => "edge[origin_id]"
      assert_select "input#edge_destination_id", :name => "edge[destination_id]"
    end
  end
end
