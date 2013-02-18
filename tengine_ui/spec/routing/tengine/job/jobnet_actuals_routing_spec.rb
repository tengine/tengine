require "spec_helper"

describe Tengine::Job::Runtime::JobnetsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/root_jobnet_actuals/1/jobnet_actuals").should route_to("tengine/job/jobnet_actuals#index", :root_jobnet_actual_id => "1")
    end

    it "routes to #new" do
      get("/tengine/job/root_jobnet_actuals/1/jobnet_actuals/new").should route_to("tengine/job/jobnet_actuals#new", :root_jobnet_actual_id => "1")
    end

    it "routes to #show" do
      get("/tengine/job/root_jobnet_actuals/1/jobnet_actuals/1").should route_to("tengine/job/jobnet_actuals#show", :id => "1", :root_jobnet_actual_id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/root_jobnet_actuals/1/jobnet_actuals/1/edit").should route_to("tengine/job/jobnet_actuals#edit", :id => "1", :root_jobnet_actual_id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/root_jobnet_actuals/1/jobnet_actuals").should route_to("tengine/job/jobnet_actuals#create", :root_jobnet_actual_id => "1")
    end

    it "routes to #update" do
      put("/tengine/job/root_jobnet_actuals/1/jobnet_actuals/1").should route_to("tengine/job/jobnet_actuals#update", :id => "1", :root_jobnet_actual_id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/root_jobnet_actuals/1/jobnet_actuals/1").should route_to("tengine/job/jobnet_actuals#destroy", :id => "1", :root_jobnet_actual_id => "1")
    end

  end
end
