require "spec_helper"

describe Tengine::Job::RootJobnetTemplatesController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/root_jobnet_templates").should route_to("tengine/job/root_jobnet_templates#index")
    end

    it "routes to #new" do
      get("/tengine/job/root_jobnet_templates/new").should route_to("tengine/job/root_jobnet_templates#new")
    end

    it "routes to #show" do
      get("/tengine/job/root_jobnet_templates/1").should route_to("tengine/job/root_jobnet_templates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/root_jobnet_templates/1/edit").should route_to("tengine/job/root_jobnet_templates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/root_jobnet_templates").should route_to("tengine/job/root_jobnet_templates#create")
    end

    it "routes to #update" do
      put("/tengine/job/root_jobnet_templates/1").should route_to("tengine/job/root_jobnet_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/root_jobnet_templates/1").should route_to("tengine/job/root_jobnet_templates#destroy", :id => "1")
    end

  end
end
