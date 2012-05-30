require "spec_helper"

describe Tengine::Core::SettingsController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/core/settings").should route_to("tengine/core/settings#index")
    end

    it "routes to #new" do
      get("/tengine/core/settings/new").should route_to("tengine/core/settings#new")
    end

    it "routes to #show" do
      get("/tengine/core/settings/1").should route_to("tengine/core/settings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/core/settings/1/edit").should route_to("tengine/core/settings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/core/settings").should route_to("tengine/core/settings#create")
    end

    it "routes to #update" do
      put("/tengine/core/settings/1").should route_to("tengine/core/settings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/core/settings/1").should route_to("tengine/core/settings#destroy", :id => "1")
    end

  end
end
