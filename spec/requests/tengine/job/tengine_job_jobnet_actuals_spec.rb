require 'spec_helper'

describe "Tengine::Job::JobnetActuals" do
  describe "GET /tengine_job_jobnet_actuals" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tengine_job_jobnet_actuals_path
      response.status.should be(200)
    end
  end
end
