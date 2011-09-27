require "spec_helper"

describe Tengine::Job::JobnetsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/jobnets").should route_to("tengine/job/jobnets#index")
    end

    it "routes to #new" do
      get("/tengine/job/jobnets/new").should route_to("tengine/job/jobnets#new")
    end

    it "routes to #show" do
      get("/tengine/job/jobnets/1").should route_to("tengine/job/jobnets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/jobnets/1/edit").should route_to("tengine/job/jobnets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/jobnets").should route_to("tengine/job/jobnets#create")
    end

    it "routes to #update" do
      put("/tengine/job/jobnets/1").should route_to("tengine/job/jobnets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/jobnets/1").should route_to("tengine/job/jobnets#destroy", :id => "1")
    end

  end
end
