require "spec_helper"

describe Tengine::Job::ScriptTemplatesController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/script_templates").should route_to("tengine/job/script_templates#index")
    end

    it "routes to #new" do
      get("/tengine/job/script_templates/new").should route_to("tengine/job/script_templates#new")
    end

    it "routes to #show" do
      get("/tengine/job/script_templates/1").should route_to("tengine/job/script_templates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/script_templates/1/edit").should route_to("tengine/job/script_templates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/script_templates").should route_to("tengine/job/script_templates#create")
    end

    it "routes to #update" do
      put("/tengine/job/script_templates/1").should route_to("tengine/job/script_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/script_templates/1").should route_to("tengine/job/script_templates#destroy", :id => "1")
    end

  end
end
