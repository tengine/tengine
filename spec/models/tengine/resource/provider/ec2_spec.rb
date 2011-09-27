# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::Provider::Ec2 do

  before(:all) do
    @credential = Tengine::Resource::Credential.new(:name => "ec2-access-key1",
      :auth_type_key => :ec2_access_key,
      :auth_values => {:access_key => 'ACCESS_KEY1', :secret_access_key => "SECRET_ACCESS_KEY1", :default_region => "us-west-1"})
  end

  before do
    @valid_attributes1 = {
      :name => "my_west-1",
      :credential => @credential
    }
  end

  describe :validation do
    context "valid" do
      subject{ Tengine::Resource::Provider::Ec2.new(@valid_attributes1) }
      its(:valid?){ should be_true }
    end

    context "invalid" do
      subject{ Tengine::Resource::Provider::Ec2.new }
      its(:valid?){ should be_false }
    end
  end

  describe 'update resources' do
    subject do
      Tengine::Resource::Provider::Ec2.create!(:name => "ec2 us-west-1", :credential => @credential)
    end

    context "物理サーバ" do

      before do
        Tengine::Resource::PhysicalServer.delete_all
        # spec/support/ec2.rb を参照してください
        RightAws::Ec2.should_receive(:new).
          with('ACCESS_KEY1', "SECRET_ACCESS_KEY1", :region => "us-west-1", :logger => Rails.logger).
          and_return(setup_ec2_stub)
      end

      shared_examples_for "取得した内容が反映される" do
        it do
          servers = subject.physical_servers.order(:provided_name)
          west_1a = servers.first
          west_1a.provider.should == subject
          west_1a.name.should == "us-west-1a"
          west_1a.provided_name.should == "us-west-1a"
          west_1a.status.should == "available"
          west_1b = servers.last
          west_1b.provider.should == subject
          west_1b.name.should == "us-west-1b"
          west_1b.provided_name.should == "us-west-1b"
          west_1b.status.should == "available"
        end
      end

      context "最初の実行時には物理サーバを登録する" do
        before do
          subject.physical_servers.count.should == 0
          subject.update_physical_servers
          subject.physical_servers.count.should == 2
        end
        it_behaves_like "取得した内容が反映される"
      end

      context "すでに1台登録されている場合" do
        before do
          subject.physical_servers.create(:name => "us-west-1a", :provided_name => "us-west-1a", :status => "available")
          subject.physical_servers.count.should == 1
          subject.update_physical_servers
          subject.physical_servers.count.should == 2
        end
        it_behaves_like "取得した内容が反映される"
      end

      context "すでに2台登録されている場合" do
        context "何も変わらない場合" do
          before do
            subject.physical_servers.create(:name => "us-west-1a", :provided_name => "us-west-1a", :status => "available")
            subject.physical_servers.create(:name => "us-west-1b", :provided_name => "us-west-1b", :status => "available")
            subject.physical_servers.count.should == 2
            subject.update_physical_servers
            subject.physical_servers.count.should == 2
          end
          it_behaves_like "取得した内容が反映される"
        end

        context "状態が変わった場合" do
          before do
            subject.physical_servers.create(:name => "us-west-1a", :provided_name => "us-west-1a", :status => "available")
            subject.physical_servers.create(:name => "us-west-1b", :provided_name => "us-west-1b", :status => "down")
            # こんな定義はないはずですが、そもそも定義がないので。
            # http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/index.html?ApiReference-query-DescribeAvailabilityZones.html
            subject.physical_servers.count.should == 2
            subject.update_physical_servers
            subject.physical_servers.count.should == 2
          end
          it_behaves_like "取得した内容が反映される"
        end

        context "名前が管理画面で変更された場合" do
          before do
            subject.physical_servers.create(:name => "foo", :provided_name => "us-west-1a", :status => "available")
            subject.physical_servers.create(:name => "us-west-1b", :provided_name => "us-west-1b", :status => "available")
            subject.physical_servers.count.should == 2
            subject.update_physical_servers
            subject.physical_servers.count.should == 2
          end

          it do
            servers = subject.physical_servers.order(:provided_name)
            west_1a = servers.first
            west_1a.provider.should == subject
            west_1a.name.should == "foo"
            west_1a.provided_name.should == "us-west-1a"
            west_1a.status.should == "available"
            west_1b = servers.last
            west_1b.provider.should == subject
            west_1b.name.should == "us-west-1b"
            west_1b.provided_name.should == "us-west-1b"
            west_1b.status.should == "available"
          end
        end
      end

      context "すでに3台登録されている場合" do
        before do
          subject.physical_servers.create(:name => "us-west-1a", :provided_name => "us-west-1a", :status => "available")
          subject.physical_servers.create(:name => "us-west-1b", :provided_name => "us-west-1b", :status => "available")
          subject.physical_servers.create(:name => "us-west-1c", :provided_name => "us-west-1c", :status => "available")
          subject.physical_servers.count.should == 3
          subject.update_physical_servers
          subject.physical_servers.count.should == 3
        end
        it "物理サーバが減るということは一大事なので、自動でデータを削除するのではなく、見つからなかったということにする" do
          servers = subject.physical_servers.order(:provided_name)
          west_1a = servers.first
          west_1a.provider.should == subject
          west_1a.name.should == "us-west-1a"
          west_1a.provided_name.should == "us-west-1a"
          west_1a.status.should == "available"
          west_1b = servers[1]
          west_1b.provider.should == subject
          west_1b.name.should == "us-west-1b"
          west_1b.provided_name.should == "us-west-1b"
          west_1b.status.should == "available"
          west_1c = servers[2]
          west_1c.provider.should == subject
          west_1c.name.should == "us-west-1c"
          west_1c.provided_name.should == "us-west-1c"
          west_1c.status.should == "not_found"
        end
      end
    end

  end

end
