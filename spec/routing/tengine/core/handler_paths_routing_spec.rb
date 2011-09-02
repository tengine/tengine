require "spec_helper"

describe Tengine::Core::HandlerPathsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/core/handler_paths").should route_to("tengine/core/handler_paths#index")
    end

    it "routes to #new" do
      get("/tengine/core/handler_paths/new").should route_to("tengine/core/handler_paths#new")
    end

    it "routes to #show" do
      get("/tengine/core/handler_paths/1").should route_to("tengine/core/handler_paths#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/core/handler_paths/1/edit").should route_to("tengine/core/handler_paths#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/core/handler_paths").should route_to("tengine/core/handler_paths#create")
    end

    it "routes to #update" do
      put("/tengine/core/handler_paths/1").should route_to("tengine/core/handler_paths#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/core/handler_paths/1").should route_to("tengine/core/handler_paths#destroy", :id => "1")
    end

  end
end
