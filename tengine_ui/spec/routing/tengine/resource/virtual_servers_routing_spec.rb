require "spec_helper"

describe Tengine::Resource::VirtualServersController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/resource/virtual_servers").should route_to("tengine/resource/virtual_servers#index")
    end

    it "routes to #new" do
      get("/tengine/resource/virtual_servers/new").should route_to("tengine/resource/virtual_servers#new")
    end

    it "routes to #show" do
      get("/tengine/resource/virtual_servers/1").should route_to("tengine/resource/virtual_servers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/resource/virtual_servers/1/edit").should route_to("tengine/resource/virtual_servers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/resource/virtual_servers").should route_to("tengine/resource/virtual_servers#create")
    end

    it "routes to #update" do
      put("/tengine/resource/virtual_servers/1").should route_to("tengine/resource/virtual_servers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/resource/virtual_servers/1").should route_to("tengine/resource/virtual_servers#destroy", :id => "1")
    end

  end
end
