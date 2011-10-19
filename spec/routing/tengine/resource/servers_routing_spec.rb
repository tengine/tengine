require "spec_helper"

describe Tengine::Resource::ServersController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/resource/servers").should route_to("tengine/resource/servers#index")
    end

    it "routes to #new" do
      get("/tengine/resource/servers/new").should route_to("tengine/resource/servers#new")
    end

    it "routes to #show" do
      get("/tengine/resource/servers/1").should route_to("tengine/resource/servers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/resource/servers/1/edit").should route_to("tengine/resource/servers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/resource/servers").should route_to("tengine/resource/servers#create")
    end

    it "routes to #update" do
      put("/tengine/resource/servers/1").should route_to("tengine/resource/servers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/resource/servers/1").should route_to("tengine/resource/servers#destroy", :id => "1")
    end

  end
end
