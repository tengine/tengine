require "spec_helper"

describe Tengine::Resource::Provider::Ec2sController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/resource/provider/ec2s").should route_to("tengine/resource/provider/ec2s#index")
    end

    it "routes to #new" do
      get("/tengine/resource/provider/ec2s/new").should route_to("tengine/resource/provider/ec2s#new")
    end

    it "routes to #show" do
      get("/tengine/resource/provider/ec2s/1").should route_to("tengine/resource/provider/ec2s#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/resource/provider/ec2s/1/edit").should route_to("tengine/resource/provider/ec2s#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/resource/provider/ec2s").should route_to("tengine/resource/provider/ec2s#create")
    end

    it "routes to #update" do
      put("/tengine/resource/provider/ec2s/1").should route_to("tengine/resource/provider/ec2s#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/resource/provider/ec2s/1").should route_to("tengine/resource/provider/ec2s#destroy", :id => "1")
    end

  end
end
