# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::PhysicalServer do
  context "nameで検索" do
    before do
      Tengine::Resource::Server.delete_all
      @fixture = GokuAtEc2ApNortheast.new
      @physical1 = @fixture.availability_zone(1)
      @virtual1 = @fixture.hadoop_master_node
    end

    context "見つかる場合" do
      it "find_by_name" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::PhysicalServer.find_by_name(@physical1.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @physical1.id
      end

      it "find_by_name!" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::PhysicalServer.find_by_name!(@physical1.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @physical1.id
      end
    end

    context "見つからない場合" do
      it "find_by_name" do
        found_credential = Tengine::Resource::PhysicalServer.find_by_name(@virtual1.name).should == nil
      end

      it "find_by_name!" do
        lambda{
          found_credential = Tengine::Resource::PhysicalServer.find_by_name!(@virtual1.name)
        }.should raise_error(Tengine::Core::FindByName::Error)
      end
    end

  end

end
