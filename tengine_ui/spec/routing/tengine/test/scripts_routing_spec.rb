require "spec_helper"

describe Tengine::Test::ScriptsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/test/scripts").should route_to("tengine/test/scripts#index")
    end

    it "routes to #new" do
      get("/tengine/test/scripts/new").should route_to("tengine/test/scripts#new")
    end

    it "routes to #show" do
      get("/tengine/test/scripts/1").should route_to("tengine/test/scripts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/test/scripts/1/edit").should route_to("tengine/test/scripts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/test/scripts").should route_to("tengine/test/scripts#create")
    end

    it "routes to #update" do
      put("/tengine/test/scripts/1").should route_to("tengine/test/scripts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/test/scripts/1").should route_to("tengine/test/scripts#destroy", :id => "1")
    end

  end
end
