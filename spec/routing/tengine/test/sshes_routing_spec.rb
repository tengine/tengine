require "spec_helper"

describe Tengine::Test::SshesController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/test/sshes").should route_to("tengine/test/sshes#index")
    end

    it "routes to #new" do
      get("/tengine/test/sshes/new").should route_to("tengine/test/sshes#new")
    end

    it "routes to #show" do
      get("/tengine/test/sshes/1").should route_to("tengine/test/sshes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/test/sshes/1/edit").should route_to("tengine/test/sshes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/test/sshes").should route_to("tengine/test/sshes#create")
    end

    it "routes to #update" do
      put("/tengine/test/sshes/1").should route_to("tengine/test/sshes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/test/sshes/1").should route_to("tengine/test/sshes#destroy", :id => "1")
    end

  end
end
