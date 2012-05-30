require "spec_helper"

describe Tengine::Core::SessionsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/core/sessions").should route_to("tengine/core/sessions#index")
    end

    it "routes to #new" do
      get("/tengine/core/sessions/new").should route_to("tengine/core/sessions#new")
    end

    it "routes to #show" do
      get("/tengine/core/sessions/1").should route_to("tengine/core/sessions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/core/sessions/1/edit").should route_to("tengine/core/sessions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/core/sessions").should route_to("tengine/core/sessions#create")
    end

    it "routes to #update" do
      put("/tengine/core/sessions/1").should route_to("tengine/core/sessions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/core/sessions/1").should route_to("tengine/core/sessions#destroy", :id => "1")
    end

  end
end
