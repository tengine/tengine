require "spec_helper"

describe Tengine::Job::ScriptsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/scripts").should route_to("tengine/job/scripts#index")
    end

    it "routes to #new" do
      get("/tengine/job/scripts/new").should route_to("tengine/job/scripts#new")
    end

    it "routes to #show" do
      get("/tengine/job/scripts/1").should route_to("tengine/job/scripts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/scripts/1/edit").should route_to("tengine/job/scripts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/scripts").should route_to("tengine/job/scripts#create")
    end

    it "routes to #update" do
      put("/tengine/job/scripts/1").should route_to("tengine/job/scripts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/scripts/1").should route_to("tengine/job/scripts#destroy", :id => "1")
    end

  end
end
