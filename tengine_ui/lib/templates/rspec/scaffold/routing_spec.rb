<% path = class_name.underscore.pluralize -%>
require "spec_helper"

describe <%= controller_class_name %>Controller do
  describe "routing" do

<% unless options[:singleton] -%>
    it "routes to #index" do
      get("/<%= path %>").should route_to("<%= path %>#index")
    end

<% end -%>
    it "routes to #new" do
      get("/<%= path %>/new").should route_to("<%= path %>#new")
    end

    it "routes to #show" do
      get("/<%= path %>/1").should route_to("<%= path %>#show", :id => "1")
    end

    it "routes to #edit" do
      get("/<%= path %>/1/edit").should route_to("<%= path %>#edit", :id => "1")
    end

    it "routes to #create" do
      post("/<%= path %>").should route_to("<%= path %>#create")
    end

    it "routes to #update" do
      put("/<%= path %>/1").should route_to("<%= path %>#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/<%= path %>/1").should route_to("<%= path %>#destroy", :id => "1")
    end

  end
end
