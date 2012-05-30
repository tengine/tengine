require 'spec_helper'

describe "tengine/job/vertices/show.html.erb" do
  before(:each) do
    @vertex = assign(:vertex, stub_model(Tengine::Job::Vertex))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
