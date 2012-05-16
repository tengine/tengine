require "spec_helper"

describe Tengine::Job::ExpansionsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/expansions").should route_to("tengine/job/expansions#index")
    end

    it "routes to #new" do
      get("/tengine/job/expansions/new").should route_to("tengine/job/expansions#new")
    end

    it "routes to #show" do
      get("/tengine/job/expansions/1").should route_to("tengine/job/expansions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/expansions/1/edit").should route_to("tengine/job/expansions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/expansions").should route_to("tengine/job/expansions#create")
    end

    it "routes to #update" do
      put("/tengine/job/expansions/1").should route_to("tengine/job/expansions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/expansions/1").should route_to("tengine/job/expansions#destroy", :id => "1")
    end

  end
end
