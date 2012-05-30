require 'spec_helper'

describe "tengine/job/vertices/new.html.erb" do
  before(:each) do
    assign(:vertex, stub_model(Tengine::Job::Vertex).as_new_record)
  end

  it "renders new vertex form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_vertices_path, :method => "post" do
    end
  end
end
