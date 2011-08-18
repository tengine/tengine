require "spec_helper"

describe Tengine::Core::DriversController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/core/drivers").should route_to("tengine/core/drivers#index")
    end

    it "routes to #new" do
      get("/tengine/core/drivers/new").should route_to("tengine/core/drivers#new")
    end

    it "routes to #show" do
      get("/tengine/core/drivers/1").should route_to("tengine/core/drivers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/core/drivers/1/edit").should route_to("tengine/core/drivers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/core/drivers").should route_to("tengine/core/drivers#create")
    end

    it "routes to #update" do
      put("/tengine/core/drivers/1").should route_to("tengine/core/drivers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/core/drivers/1").should route_to("tengine/core/drivers#destroy", :id => "1")
    end

  end
end
