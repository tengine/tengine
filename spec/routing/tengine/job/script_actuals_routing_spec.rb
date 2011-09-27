require "spec_helper"

describe Tengine::Job::ScriptActualsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/script_actuals").should route_to("tengine/job/script_actuals#index")
    end

    it "routes to #new" do
      get("/tengine/job/script_actuals/new").should route_to("tengine/job/script_actuals#new")
    end

    it "routes to #show" do
      get("/tengine/job/script_actuals/1").should route_to("tengine/job/script_actuals#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/script_actuals/1/edit").should route_to("tengine/job/script_actuals#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/script_actuals").should route_to("tengine/job/script_actuals#create")
    end

    it "routes to #update" do
      put("/tengine/job/script_actuals/1").should route_to("tengine/job/script_actuals#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/script_actuals/1").should route_to("tengine/job/script_actuals#destroy", :id => "1")
    end

  end
end
