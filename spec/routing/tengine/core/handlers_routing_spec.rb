require "spec_helper"

describe Tengine::Core::HandlersController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/core/handlers").should route_to("tengine/core/handlers#index")
    end

    it "routes to #new" do
      get("/tengine/core/handlers/new").should route_to("tengine/core/handlers#new")
    end

    it "routes to #show" do
      get("/tengine/core/handlers/1").should route_to("tengine/core/handlers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/core/handlers/1/edit").should route_to("tengine/core/handlers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/core/handlers").should route_to("tengine/core/handlers#create")
    end

    it "routes to #update" do
      put("/tengine/core/handlers/1").should route_to("tengine/core/handlers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/core/handlers/1").should route_to("tengine/core/handlers#destroy", :id => "1")
    end

  end
end
