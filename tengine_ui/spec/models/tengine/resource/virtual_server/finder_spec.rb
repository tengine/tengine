# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::VirtualServer::Finder do
  subject {Tengine::Resource::VirtualServer::Finder}

  it "初期化時はnilが入っていること" do
    finder = subject.new

    finder.attributes do |attr_name|
      finder.send(attr_name).should == nil
    end

    finder = subject.new(finder:{})

    finder.attributes do |attr_name|
      finder.send(attr_name).should == nil
    end
  end

  it "Tengine::ResourceWakame::Provider::VIRTUAL_SERVER_STATESがstatus_cdに登録されていること" do
    Tengine::ResourceWakame::Provider::VIRTUAL_SERVER_STATES.each do |status|
      entry = subject.status_enum[status]
      entry.id.to_s.should == status.to_s
      entry.name.to_s.should == status.to_s
    end
  end

  it "finded_by_virtual_server?" do
    subject.new.should_not be_finded_by_virtual_server
    subject.new(virtual_server_name:"test").should be_finded_by_virtual_server
    subject.new(provided_id:"12434").should be_finded_by_virtual_server
    subject.new(description:"desc").should be_finded_by_virtual_server
    subject.new(virtual_server_image_name:"image").should be_finded_by_virtual_server
    subject.new(status_ids:["starting"]).should be_finded_by_virtual_server
    subject.new(status_ids:["nostatus"]).should_not be_finded_by_virtual_server
    subject.new(status_ids:[]).should_not be_finded_by_virtual_server
  end

  it "scopeで絞り込みができること" do
    Tengine::Resource::Provider.delete_all
    @pr = Tengine::Resource::Provider.create!(:name => "testprovider")
    Tengine::Resource::VirtualServer.delete_all
    @virtual_server1 = Tengine::Resource::VirtualServer.create!(
      :provider_id => @pr.id,
      :name => "vserver1",
      :provided_id => "i0002",
      :description => "v2Description",
      :status => "starting",
      :addresses => {"ip_address"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_id => "ami1",
      :provided_type_id => "large",
    )
    @virtual_server2 = Tengine::Resource::VirtualServer.create!(
      :provider_id => @pr.id,
      :name => "vserver2",
      :provided_id => "i0004",
      :description => "v3Description",
      :status => "running",
      :addresses => {"ip_address"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_id => "ami2",
      :provided_type_id => "large",
    )
    Tengine::Resource::VirtualServerImage.delete_all
    @vimage1 = Tengine::Resource::VirtualServerImage.create!(
      :provider_id => @pr.id,
      :name => "vimage1",
      :provided_id => "ami1",
    )
    @vimage2 = Tengine::Resource::VirtualServerImage.create!(
      :provider_id => @pr.id,
      :name => "vimage2",
      :provided_id => "ami2",
    )
    criteria = Mongoid::Criteria.new(Tengine::Resource::VirtualServer)
    result = subject.new(virtual_server_name:"vserver").scope(criteria)
    result.count.should == 2
    result.each {|record| record.name.should =~ /vserver/ }

    result = subject.new(provided_id:"i0004").scope(criteria)
    result.count.should == 1
    result.first.provided_id == "i0004"

    result = subject.new(description:"Desc").scope(criteria)
    result.count.should == 2
    result.each {|record| record.description =~ /Desc/ }

    result = subject.new(status_ids:["starting", "running"]).scope(criteria)
    result.count.should == 2
    result.each {|record| ["starting", "running"].should be_include(record.status.to_s) }

    result = \
      subject.new(virtual_server_name:"vserver", status_ids:["starting"]).scope(criteria)
    result.count.should == 1
    result.first.should == @virtual_server1

    result = subject.new(description:"Desc", provided_id:"i0004").scope(criteria)
    result.count.should == 1
    result.first.should == @virtual_server2

    result = subject.new(virtual_server_image_name:"image").scope(criteria)
    result.count.should == 2
    result.each do |record|
      vi = Tengine::Resource::VirtualServerImage.where(
        provided_id:record.provided_image_id).first
      vi.name.should =~ /image/
    end

    result = subject.new(virtual_server_image_name:"notmatch").scope(criteria)
    result.count.should == 0

    @virtual_server3 = Tengine::Resource::VirtualServer.create!(
      :provider_id => @pr.id,
      :name => "aserver",
      :provided_id => "i0000",
      :description => "Description",
      :status => "running",
      :addresses => {"ip_address"=>"192.168.1.1", "eth1"=>"10.10.10.1"},
      :properties => {"a"=>"1", "b"=>"2"},
      :provided_image_id => "ami2",
      :provided_type_id => "large",
    )

    result = subject.new.scope(criteria)
    result.count == 3
    [@virtual_server3, @virtual_server1, @virtual_server2].each_with_index do |vs, i|
      result[i].should == vs
    end
  end
end
