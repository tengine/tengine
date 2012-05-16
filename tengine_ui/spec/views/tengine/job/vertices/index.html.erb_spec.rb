require 'spec_helper'

describe "tengine/job/vertices/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:vertices, [
      stub_model(Tengine::Job::Vertex),
      stub_model(Tengine::Job::Vertex)
    ]))
  end

  it "renders a list of tengine_job_vertices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
