require "spec_helper"

describe Tengine::Job::EdgesController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/edges").should route_to("tengine/job/edges#index")
    end

    it "routes to #new" do
      get("/tengine/job/edges/new").should route_to("tengine/job/edges#new")
    end

    it "routes to #show" do
      get("/tengine/job/edges/1").should route_to("tengine/job/edges#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/edges/1/edit").should route_to("tengine/job/edges#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/edges").should route_to("tengine/job/edges#create")
    end

    it "routes to #update" do
      put("/tengine/job/edges/1").should route_to("tengine/job/edges#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/edges/1").should route_to("tengine/job/edges#destroy", :id => "1")
    end

  end
end
