require "spec_helper"

describe Tengine::Core::HandlersController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/core/drivers/11/handlers").should route_to("tengine/core/handlers#index", :driver_id => "11")
    end

    it "routes to #new" do
      get("/tengine/core/drivers/11/handlers/new").should route_to("tengine/core/handlers#new", :driver_id => "11")
    end

    it "routes to #show" do
      get("/tengine/core/drivers/11/handlers/1").should route_to("tengine/core/handlers#show", :driver_id => "11", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/core/drivers/11/handlers/1/edit").should route_to("tengine/core/handlers#edit", :driver_id => "11", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/core/drivers/11/handlers").should route_to("tengine/core/handlers#create", :driver_id => "11")
    end

    it "routes to #update" do
      put("/tengine/core/drivers/11/handlers/1").should route_to("tengine/core/handlers#update", :driver_id => "11", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/core/drivers/11/handlers/1").should route_to("tengine/core/handlers#destroy", :driver_id => "11", :id => "1")
    end

  end
end
