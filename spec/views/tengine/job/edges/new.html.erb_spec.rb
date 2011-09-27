require 'spec_helper'

describe "tengine/job/edges/new.html.erb" do
  before(:each) do
    assign(:edge, stub_model(Tengine::Job::Edge,
      :status_cd => 1,
      :origin_id => "MyString",
      :destination_id => "MyString"
    ).as_new_record)
  end

  it "renders new edge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_edges_path, :method => "post" do
      assert_select "input#edge_status_cd", :name => "edge[status_cd]"
      assert_select "input#edge_origin_id", :name => "edge[origin_id]"
      assert_select "input#edge_destination_id", :name => "edge[destination_id]"
    end
  end
end
