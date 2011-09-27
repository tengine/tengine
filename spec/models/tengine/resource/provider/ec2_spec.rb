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
          servers = subject.physical_servers.order(:provided_name, :asc)
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

        context "nameが管理画面で変更されていた場合" do
          before do
            subject.physical_servers.create(:name => "foo", :provided_name => "us-west-1a", :status => "available")
            subject.physical_servers.create(:name => "us-west-1b", :provided_name => "us-west-1b", :status => "available")
            subject.physical_servers.count.should == 2
            subject.update_physical_servers
            subject.physical_servers.count.should == 2
          end

          it do
            servers = subject.physical_servers.order(:provided_name, :asc)
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
          servers = subject.physical_servers.order(:provided_name, :asc)
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

    context "仮想サーバ" do
      before do
        @now = Time.now
        Time.stub!(:now).and_return(@now)
        Tengine::Resource::PhysicalServer.delete_all
        Tengine::Resource::VirtualServer.delete_all
        Tengine::Resource::VirtualServerImage.delete_all
        @us_west_1a = subject.physical_servers.create(:name => "us-west-1a", :provided_name => "us-west-1a", :status => "available")
        @us_west_1b = subject.physical_servers.create(:name => "us-west-1b", :provided_name => "us-west-1b", :status => "available")
        @ami_1 = subject.virtual_server_images.create(:name => "ami-11111111", :provided_name => "ami-11111111")
        @response_base = {
          # 起動後変更がない属性
          # :aws_instance_id    => "i-11111111",
          :aws_image_id=>"ami-11111111",
          :aws_availability_zone => "us-east-1a",
          :ssh_key_name=>"tengine",
          :aws_groups=>["default", "test2"],
          :aws_launch_time => Time.now.iso8601,
          :ami_launch_index=>"0",
          :architecture=>"i386",
          #
          # 起動後変更がありえる属性
          # :dns_name=>"ec2-184-72-203-101.us-west-1.compute.amazonaws.com",
          # :ip_address=>"184.72.20.101",
          # :private_dns_name=>"ip-10-162-153-101.us-west-1.compute.internal",
          # :private_ip_address=>"10.162.153.101",
          :aws_state_code=>16,
          :aws_state=>"running",
          :aws_reason=>"",
        }

        @base_attrs = {
          :status => "running",
          :provided_image_name => "ami-11111111",
          :properties => {
            :aws_availability_zone => "us-east-1a",
            :ssh_key_name=>"tengine",
            :aws_groups=>["default", "test2"],
            :aws_launch_time => @now.iso8601,
            :ami_launch_index=>"0",
            :architecture=>"i386",
          }
        }

        @server_base_attrs = [
          {
            :name          => "i-11111111",
            :provided_name => "i-11111111",
            :public_hostname => "ec2-184-72-203-101.us-west-1.compute.amazonaws.com",
            :public_ipv4 => "184.72.20.101",
            :private_hostname => "ip-10-162-153-101.us-west-1.compute.internal",
            :private_ipv4 => "10.162.153.101",
          },
          {
            :name          => "i-22222222",
            :provided_name => "i-22222222",
            :public_hostname => "ec2-184-72-203-102.us-west-1.compute.amazonaws.com",
            :public_ipv4 => "184.72.20.102",
            :private_hostname => "ip-10-162-153-102.us-west-1.compute.internal",
            :private_ipv4 => "10.162.153.102",
          },
          {
            :name          => "i-33333333",
            :provided_name => "i-33333333",
            :public_hostname => "ec2-184-72-203-103.us-west-1.compute.amazonaws.com",
            :public_ipv4 => "184.72.20.103",
            :private_hostname => "ip-10-162-153-103.us-west-1.compute.internal",
            :private_ipv4 => "10.162.153.103",
          },
          {
            :name          => "i-44444444",
            :provided_name => "i-44444444",
            :public_hostname => "ec2-184-72-203-104.us-west-1.compute.amazonaws.com",
            :public_ipv4 => "184.72.20.104",
            :private_hostname => "ip-10-162-153-104.us-west-1.compute.internal",
            :private_ipv4 => "10.162.153.104",
          }
        ]

        describe_instances_item = lambda do |*args|
          index, options = *args
          result = @response_base.merge({
              :aws_instance_id => "i-" << (index.to_s * 8),
              :dns_name=>"ec2-184-72-203-#{index + 100}.us-west-1.compute.amazonaws.com",
              :ip_address=>"184.72.20.#{index + 100}",
              :private_dns_name=>"ip-10-162-153-#{index + 100}.us-west-1.compute.internal",
              :private_ip_address=>"10.162.153.#{index + 100}",
            })
          result.update(options) if options
          result
        end
        # spec/support/ec2.rb を参照してください
        mock_ec2 = setup_ec2_stub
        mock_ec2.stub!(:describe_instances).and_return([
            describe_instances_item.call(1),
            describe_instances_item.call(2),
            describe_instances_item.call(3),
          ])
        RightAws::Ec2.should_receive(:new).
          with('ACCESS_KEY1', "SECRET_ACCESS_KEY1", :region => "us-west-1", :logger => Rails.logger).
          and_return(mock_ec2)
      end

      shared_examples_for "取得したstaticな情報が反映される" do
        it do
          assert_server = lambda do |server|
            server.provided_image_name.should == "ami-11111111"
            server.properties.should == {
              'aws_availability_zone' => "us-east-1a",
              'ssh_key_name'=>"tengine",
              'aws_groups'=>["default", "test2"],
              'aws_launch_time' => @now.iso8601,
              'ami_launch_index'=>"0",
              'architecture'=>"i386",
              'aws_reason' => ""
            }
          end
          servers = subject.virtual_servers.order(:provided_name, :asc).to_a
          servers.each(&assert_server)
        end
      end

      shared_examples_for "取得した名前が反映される" do
        it do
          assert_server = lambda do |server, index|
            name = "i-" + ((index + 1).to_s * 8)
            server.name.should == name
            server.provided_name.should == name
          end
          servers = subject.virtual_servers.order(:provided_name, :asc).to_a
          servers.each_with_index(&assert_server)
        end
      end

      shared_examples_for "取得したIPとホスト名が反映される" do
        it do
          assert_server = lambda do |server, index|
            server.public_hostname.should == "ec2-184-72-203-#{index + 101}.us-west-1.compute.amazonaws.com"
            server.public_ipv4.should == "184.72.20.#{index + 101}"
            server.private_hostname.should == "ip-10-162-153-#{index + 101}.us-west-1.compute.internal"
            server.private_ipv4.should == "10.162.153.#{index + 101}"
          end
          servers = subject.virtual_servers.order(:provided_name, :asc).to_a
          servers.each_with_index(&assert_server)
        end
      end

      shared_examples_for "取得した状態が反映される" do
        it do
          servers = subject.virtual_servers.order(:provided_name, :asc).to_a
          servers.each do |server|
            server.status.should == "running"
          end
        end
      end

      context "最初の実行時には物理サーバを登録する" do
        before do
          subject.virtual_servers.count.should == 0
          subject.update_virtual_servers
          subject.virtual_servers.count.should == 3
        end
        it_behaves_like "取得したstaticな情報が反映される"
        it_behaves_like "取得した名前が反映される"
        it_behaves_like "取得したIPとホスト名が反映される"
        it_behaves_like "取得した状態が反映される"
      end

      context "すでに1台登録されている場合" do
        before do
          subject.virtual_servers.create(@base_attrs.merge({
              :name          => "i-11111111",
              :provided_name => "i-11111111",
              :public_hostname => "ec2-184-72-203-101.us-west-1.compute.amazonaws.com",
              :public_ipv4 => "184.72.20.101",
              :private_hostname => "ip-10-162-153-101.us-west-1.compute.internal",
              :private_ipv4 => "10.162.153.101",
              }))
          subject.virtual_servers.count.should == 1
          subject.update_virtual_servers
          subject.virtual_servers.count.should == 3
        end
        it_behaves_like "取得したstaticな情報が反映される"
        it_behaves_like "取得した名前が反映される"
        it_behaves_like "取得したIPとホスト名が反映される"
        it_behaves_like "取得した状態が反映される"
      end

      context "すでに3台登録されている場合" do
        context "何も変わらない場合" do
          before do
            subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[0]))
            subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[1]))
            subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[2]))
            subject.virtual_servers.count.should == 3
            subject.update_virtual_servers
            subject.virtual_servers.count.should == 3
          end
          it_behaves_like "取得したstaticな情報が反映される"
          it_behaves_like "取得した名前が反映される"
          it_behaves_like "取得したIPとホスト名が反映される"
          it_behaves_like "取得した状態が反映される"
        end

        context "状態が変わった場合" do
          before do
            subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[0]))
            subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[1]).merge(:state => "shutting_down"))
            subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[2]))
            subject.virtual_servers.count.should == 3
            subject.update_virtual_servers
            subject.virtual_servers.count.should == 3
          end
          it_behaves_like "取得したstaticな情報が反映される"
          it_behaves_like "取得した名前が反映される"
          it_behaves_like "取得したIPとホスト名が反映される"
          it_behaves_like "取得した状態が反映される"
        end

        context "nameが管理画面で変更されていた場合" do
          before do
            subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[0]).merge(:name => "master1"))
            subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[1]).merge(:name => "slave1"))
            subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[2]).merge(:name => "slave2"))
            subject.virtual_servers.count.should == 3
            subject.update_virtual_servers
            subject.virtual_servers.count.should == 3
          end
          it_behaves_like "取得したstaticな情報が反映される"
          # it_behaves_like "取得した名前が反映される"
          it_behaves_like "取得したIPとホスト名が反映される"
          it_behaves_like "取得した状態が反映される"

          it "nameはTenigneで指定するものなので更新されません" do
            servers = subject.virtual_servers.order(:provided_name, :asc).to_a
            servers[0].name.should == "master1"
            servers[1].name.should == "slave1"
            servers[2].name.should == "slave2"
            servers[0].provided_name.should == "i-11111111"
            servers[1].provided_name.should == "i-22222222"
            servers[2].provided_name.should == "i-33333333"
          end
        end
      end

      context "すでに4台登録されている場合" do
        before do
          subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[0]))
          subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[1]))
          subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[2]))
          subject.virtual_servers.create(@base_attrs.merge(@server_base_attrs[3]))
          subject.virtual_servers.count.should == 4
          subject.update_virtual_servers
          subject.reload
          subject.virtual_servers.count.should == 3
        end
        # 仮想サーバ基盤が管理している仮想サーバが減ることは通常あり得ることなので、物理サーバの場合と違ってTenigneもデータを削除する
        it_behaves_like "取得したstaticな情報が反映される"
        it_behaves_like "取得した名前が反映される"
        it_behaves_like "取得したIPとホスト名が反映される"
        it_behaves_like "取得した状態が反映される"
      end

    end
  end

end
