require "spec_helper"

describe Tengine::Resource::ProvidersController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/resource/providers").should route_to("tengine/resource/providers#index")
    end

    it "routes to #new" do
      get("/tengine/resource/providers/new").should route_to("tengine/resource/providers#new")
    end

    it "routes to #show" do
      get("/tengine/resource/providers/1").should route_to("tengine/resource/providers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/resource/providers/1/edit").should route_to("tengine/resource/providers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/resource/providers").should route_to("tengine/resource/providers#create")
    end

    it "routes to #update" do
      put("/tengine/resource/providers/1").should route_to("tengine/resource/providers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/resource/providers/1").should route_to("tengine/resource/providers#destroy", :id => "1")
    end

  end
end
