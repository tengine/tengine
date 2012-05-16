require 'spec_helper'

describe "Tengine::Job::Edges" do
  describe "GET /tengine_job_edges" do
    before do
      Tengine::Job::Vertex.delete_all
      @jobnet = Tengine::Job::JobnetTemplate.create!(name:"root_jobnet1")
    end

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tengine_job_jobnet_edges_path(@jobnet)
      response.status.should be(200)
    end
  end
end
