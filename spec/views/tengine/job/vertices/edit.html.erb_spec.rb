require 'spec_helper'

describe "tengine/job/vertices/edit.html.erb" do
  before(:each) do
    @vertex = assign(:vertex, stub_model(Tengine::Job::Vertex))
  end

  it "renders the edit vertex form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_vertices_path(@vertex), :method => "post" do
    end
  end
end
