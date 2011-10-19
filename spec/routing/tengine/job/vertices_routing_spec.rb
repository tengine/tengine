require "spec_helper"

describe Tengine::Job::VerticesController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/vertices").should route_to("tengine/job/vertices#index")
    end

    it "routes to #new" do
      get("/tengine/job/vertices/new").should route_to("tengine/job/vertices#new")
    end

    it "routes to #show" do
      get("/tengine/job/vertices/1").should route_to("tengine/job/vertices#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/vertices/1/edit").should route_to("tengine/job/vertices#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/vertices").should route_to("tengine/job/vertices#create")
    end

    it "routes to #update" do
      put("/tengine/job/vertices/1").should route_to("tengine/job/vertices#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/vertices/1").should route_to("tengine/job/vertices#destroy", :id => "1")
    end

  end
end
