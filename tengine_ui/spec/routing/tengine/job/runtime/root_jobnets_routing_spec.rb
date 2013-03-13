require "spec_helper"

describe Tengine::Job::Runtime::RootJobnetsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/runtime/root_jobnets").should route_to("tengine/job/runtime/root_jobnets#index")
    end

    it "routes to #new" do
      get("/tengine/job/runtime/root_jobnets/new").should route_to("tengine/job/runtime/root_jobnets#new")
    end

    it "routes to #show" do
      get("/tengine/job/runtime/root_jobnets/1").should route_to("tengine/job/runtime/root_jobnets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/runtime/root_jobnets/1/edit").should route_to("tengine/job/runtime/root_jobnets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/runtime/root_jobnets").should route_to("tengine/job/runtime/root_jobnets#create")
    end

    it "routes to #update" do
      put("/tengine/job/runtime/root_jobnets/1").should route_to("tengine/job/runtime/root_jobnets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/runtime/root_jobnets/1").should route_to("tengine/job/runtime/root_jobnets#destroy", :id => "1")
    end

  end
end
