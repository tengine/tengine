require 'spec_helper'

describe "Tengine::Job::Runtime::RootJobnets" do
  describe "GET /tengine_job_runtime_root_jobnets" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tengine_job_runtime_root_jobnets_path
      response.status.should be(200)
    end
  end
end
