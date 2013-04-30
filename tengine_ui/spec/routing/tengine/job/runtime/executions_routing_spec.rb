require "spec_helper"

describe Tengine::Job::Runtime::ExecutionsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/runtime/executions").should route_to("tengine/job/runtime/executions#index")
    end

    it "routes to #new" do
      get("/tengine/job/runtime/executions/new").should route_to("tengine/job/runtime/executions#new")
    end

    it "routes to #show" do
      get("/tengine/job/runtime/executions/1").should route_to("tengine/job/runtime/executions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/runtime/executions/1/edit").should route_to("tengine/job/runtime/executions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/runtime/executions").should route_to("tengine/job/runtime/executions#create")
    end

    it "routes to #update" do
      put("/tengine/job/runtime/executions/1").should route_to("tengine/job/runtime/executions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/runtime/executions/1").should route_to("tengine/job/runtime/executions#destroy", :id => "1")
    end

  end
end
