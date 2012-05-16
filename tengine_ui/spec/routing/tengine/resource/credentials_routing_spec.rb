require "spec_helper"

describe Tengine::Resource::CredentialsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/resource/credentials").should route_to("tengine/resource/credentials#index")
    end

    it "routes to #new" do
      get("/tengine/resource/credentials/new").should route_to("tengine/resource/credentials#new")
    end

    it "routes to #show" do
      get("/tengine/resource/credentials/1").should route_to("tengine/resource/credentials#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/resource/credentials/1/edit").should route_to("tengine/resource/credentials#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/resource/credentials").should route_to("tengine/resource/credentials#create")
    end

    it "routes to #update" do
      put("/tengine/resource/credentials/1").should route_to("tengine/resource/credentials#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/resource/credentials/1").should route_to("tengine/resource/credentials#destroy", :id => "1")
    end

  end
end
