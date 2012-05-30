require "spec_helper"

describe Tengine::Resource::VirtualServerImagesController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/resource/virtual_server_images").should route_to("tengine/resource/virtual_server_images#index")
    end

    it "routes to #new" do
      get("/tengine/resource/virtual_server_images/new").should route_to("tengine/resource/virtual_server_images#new")
    end

    it "routes to #show" do
      get("/tengine/resource/virtual_server_images/1").should route_to("tengine/resource/virtual_server_images#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/resource/virtual_server_images/1/edit").should route_to("tengine/resource/virtual_server_images#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/resource/virtual_server_images").should route_to("tengine/resource/virtual_server_images#create")
    end

    it "routes to #update" do
      put("/tengine/resource/virtual_server_images/1").should route_to("tengine/resource/virtual_server_images#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/resource/virtual_server_images/1").should route_to("tengine/resource/virtual_server_images#destroy", :id => "1")
    end

  end
end
