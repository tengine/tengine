require "spec_helper"

describe Tengine::Core::DriversController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine_core_drivers").should route_to("tengine_core_drivers#index")
    end

    it "routes to #new" do
      get("/tengine_core_drivers/new").should route_to("tengine_core_drivers#new")
    end

    it "routes to #show" do
      get("/tengine_core_drivers/1").should route_to("tengine_core_drivers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine_core_drivers/1/edit").should route_to("tengine_core_drivers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine_core_drivers").should route_to("tengine_core_drivers#create")
    end

    it "routes to #update" do
      put("/tengine_core_drivers/1").should route_to("tengine_core_drivers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine_core_drivers/1").should route_to("tengine_core_drivers#destroy", :id => "1")
    end

  end
end
