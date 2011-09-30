require "spec_helper"

describe Tengine::Job::CategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/tengine/job/categories").should route_to("tengine/job/categories#index")
    end

    it "routes to #new" do
      get("/tengine/job/categories/new").should route_to("tengine/job/categories#new")
    end

    it "routes to #show" do
      get("/tengine/job/categories/1").should route_to("tengine/job/categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tengine/job/categories/1/edit").should route_to("tengine/job/categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tengine/job/categories").should route_to("tengine/job/categories#create")
    end

    it "routes to #update" do
      put("/tengine/job/categories/1").should route_to("tengine/job/categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tengine/job/categories/1").should route_to("tengine/job/categories#destroy", :id => "1")
    end

  end
end
