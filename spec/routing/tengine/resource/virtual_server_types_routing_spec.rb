require "spec_helper"

describe Tengine::Resource::VirtualServerTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/resource/virtual_server_types").should route_to("tengine/resource/virtual_server_types#index")
    end

    it "routes to #new" do
      get("/tengine/resource/virtual_server_types/new").should route_to("tengine/resource/virtual_server_types#new")
    end

    it "routes to #show" do
      get("/tengine/resource/virtual_server_types/1").should route_to("tengine/resource/virtual_server_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/resource/virtual_server_types/1/edit").should route_to("tengine/resource/virtual_server_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/resource/virtual_server_types").should route_to("tengine/resource/virtual_server_types#create")
    end

    it "routes to #update" do
      put("/tengine/resource/virtual_server_types/1").should route_to("tengine/resource/virtual_server_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/resource/virtual_server_types/1").should route_to("tengine/resource/virtual_server_types#destroy", :id => "1")
    end

  end
end
