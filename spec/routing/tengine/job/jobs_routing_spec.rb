require "spec_helper"

describe Tengine::Job::JobsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/jobs").should route_to("tengine/job/jobs#index")
    end

    it "routes to #new" do
      get("/tengine/job/jobs/new").should route_to("tengine/job/jobs#new")
    end

    it "routes to #show" do
      get("/tengine/job/jobs/1").should route_to("tengine/job/jobs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/jobs/1/edit").should route_to("tengine/job/jobs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/jobs").should route_to("tengine/job/jobs#create")
    end

    it "routes to #update" do
      put("/tengine/job/jobs/1").should route_to("tengine/job/jobs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/jobs/1").should route_to("tengine/job/jobs#destroy", :id => "1")
    end

  end
end
