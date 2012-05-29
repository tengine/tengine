require 'spec_helper'

describe Tengine::Resource::PhysicalServer do
  describe :by_provided_id do
    before do
      @valid_provided_id1 = "i-000001"
    end

    shared_examples_for "returns nil for blank provided_id" do
      it "returns nil for nil" do
        Tengine::Resource::PhysicalServer.by_provided_id(nil).should == nil
      end
      it "returns nil for blank String" do
        Tengine::Resource::PhysicalServer.by_provided_id("").should == nil
      end
    end

    context "PhysicalServer exists" do
      before do
        Tengine::Resource::PhysicalServer.delete_all
        @physical_server1 = Tengine::Resource::PhysicalServer.create!(:name => "server1", :provided_id => @valid_provided_id1)
      end

      it "returns the server for valid provided_id" do
        Tengine::Resource::PhysicalServer.by_provided_id(@valid_provided_id1).id.should == @physical_server1.id
      end
      it_should_behave_like "returns nil for blank provided_id"
    end

    context "PhysicalServer doesn't exist" do
      before do
        Tengine::Resource::PhysicalServer.delete_all
      end

      it "returns the server for valid provided_id" do
        Tengine::Resource::PhysicalServer.by_provided_id(@valid_provided_id1).should == nil
      end
      it_should_behave_like "returns nil for blank provided_id"
    end


  end

end
