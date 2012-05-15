# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::VirtualServer do

  before(:all) do
    @fixture = GokuAtEc2ApNortheast.new
  end

  context "サーバの状態が変わったとき" do
    before do
      @fixture.virtual_servers
    end

    it "railsサーバが落とされたことを検出したのでサーバに反映できる" do
      rails1 = @fixture.rails_server(1)
      rails1.status = "terminated"
      rails1.save!
    end
  end


  context "nameで検索" do
    before do
      Tengine::Resource::Server.delete_all
      @fixture = GokuAtEc2ApNortheast.new
      @physical1 = @fixture.availability_zone(1)
      @virtual1 = @fixture.hadoop_master_node
      @virtual2 = @fixture.hadoop_slave_node(1)
    end

    context "見つかる場合" do
      it "find_by_name" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::VirtualServer.find_by_name(@virtual1.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @virtual1.id
      end

      it "find_by_name!" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::VirtualServer.find_by_name!(@virtual2.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @virtual2.id
      end
    end

    context "見つからない場合" do
      it "find_by_name" do
        found_credential = Tengine::Resource::VirtualServer.find_by_name(@physical1).should == nil
      end

      it "find_by_name!" do
        lambda{
          found_credential = Tengine::Resource::VirtualServer.find_by_name!(@physical1)
        }.should raise_error(Tengine::Core::FindByName::Error)
      end
    end

  end

  describe :launch_mode? do
    context "launch_countが設定されていたらtrue" do
      subject{ Tengine::Resource::VirtualServer.new(:launch_count => '1') }
      its(:launch_count){ should == 1}
      its(:launch_mode?){ should == true}
    end

    context "launch_countがnilならばfalse" do
      subject{ Tengine::Resource::VirtualServer.new(:launch_count => nil) }
      its(:launch_count){ should == nil}
      its(:launch_mode?){ should == false}
    end
  end

  describe :launch_mode do
    before do
      I18n.locale = :ja
    end

    before "既に重複する名前のモデルが登録されている場合" do
      Tengine::Resource::VirtualServer.tap do |c|
        c.delete_all
        c.create!(:name => "test003", :provided_id => "provided_id_003")
        c.create!(:name => "test004", :provided_id => "provided_id_004")
      end
    end

    it "testを2台起動しようとした場合" do
      s = Tengine::Resource::VirtualServer.new(:name => "test", :launch_count => 2)
      s.valid?
      s.errors.full_messages.should == []
      s.errors[:name].should == []
    end

    it "testを3台起動しようとした場合" do
      s = Tengine::Resource::VirtualServer.new(:name => "test", :launch_count => 3)
      s.valid?
      s.errors[:name].should == ["に指定されたtest003は既に登録されています"]
      s.errors.full_messages.should == ["Name に指定されたtest003は既に登録されています"]
    end

    it "testを4台起動しようとした場合" do
      s = Tengine::Resource::VirtualServer.new(:name => "test", :launch_count => 4)
      s.valid?
      s.errors[:name].should == ["に指定されたtest003,test004は既に登録されています"]
      s.errors.full_messages.should == ["Name に指定されたtest003,test004は既に登録されています"]
    end
  end


end
