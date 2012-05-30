require "spec_helper"

describe Tengine::Core::EventsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/core/events").should route_to("tengine/core/events#index")
    end

    it "routes to #new" do
      get("/tengine/core/events/new").should route_to("tengine/core/events#new")
    end

    it "routes to #show" do
      get("/tengine/core/events/1").should route_to("tengine/core/events#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/core/events/1/edit").should route_to("tengine/core/events#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/core/events").should route_to("tengine/core/events#create")
    end

    it "routes to #update" do
      put("/tengine/core/events/1").should route_to("tengine/core/events#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/core/events/1").should route_to("tengine/core/events#destroy", :id => "1")
    end

  end
end
