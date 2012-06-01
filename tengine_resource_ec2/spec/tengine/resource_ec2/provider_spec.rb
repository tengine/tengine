# -*- coding: utf-8 -*-
require 'spec_helper'

require 'right_aws'
require 'tempfile'

describe Tengine::ResourceEc2::Provider do
  before do
    Tengine::ResourceEc2::Provider.delete_all
    @access_key1 = 'ACCESS_KEY1'
    @secret_access_key1 = 'SECRET_ACCESS_KEY1'
    @conn1 = {'access_key' => @access_key1, 'secret_access_key' => @secret_access_key1, 'region' => "us-west-1"}
    @valid_attributes1 = {
      :name => "my_west-1",
      :connection_settings => @conn1
    }
  end

  before do
    @access_key_file = Tempfile.new("access_key_file")
    @access_key_file.write(@access_key1)
    @access_key_file.chmod(0444)
    @access_key_file.flush

    @secret_access_key_file = Tempfile.new("secret_access_key_file")
    @secret_access_key_file.write(@secret_access_key1)
    @secret_access_key_file.chmod(0400)
    @secret_access_key_file.flush

    @conn2 = {'access_key_file' => @access_key_file.path, 'secret_access_key_file' => @secret_access_key_file.path, 'region' => "us-west-1"}
    @valid_attributes2 = {
      :name => "my_west-1",
      :connection_settings => @conn2
    }
  end

  after do
    @access_key_file.close(:real)
    @secret_access_key_file.close(:real)
  end

  describe 'access_key and secret_access_key' do
    context "@valid_attributes1" do
      subject{ Tengine::ResourceEc2::Provider.new(@valid_attributes1) }
      its(:access_key){ should == @conn1['access_key']}
      its(:secret_access_key){ should == @conn1['secret_access_key']}
    end

    context "@valid_attributes2" do
      subject{ Tengine::ResourceEc2::Provider.new(@valid_attributes2) }
      its(:access_key){ should == @conn1['access_key']}
      its(:secret_access_key){ should == @conn1['secret_access_key']}
    end
  end

  describe :validation do
    context "valid" do
      context "key_specified_directlly" do
        subject{ Tengine::ResourceEc2::Provider.new(@valid_attributes1) }
        its(:valid?){ should be_true }
      end

      context "key_specified_by_file" do
        subject{ Tengine::ResourceEc2::Provider.new(@valid_attributes2) }
        its(:valid?){ should be_true }
      end

      # 本来警告にしたいところですが、connection_settingsが不正でもエラーにはしません。
      context "empty connection_settings" do
        subject{ Tengine::ResourceEc2::Provider.new(:name => "my_east-1") }
        its(:valid?){ should be_true }
      end

      # 本来警告にしたいところですが、connection_settingsが不正でもエラーにはしません。
      context "invalid filepath in connection_settings" do
        subject{ Tengine::ResourceEc2::Provider.new(:name => "my_east-1",
            :connection_settings => {
              :access_key_file => "/unexist/access/key/file/path",
              :secret_access_key_file => "/unexist/secret/access/key/file/path"
            }) }
        its(:valid?){ should be_true }
      end
    end

    context "invalid" do
      context "empty attributes" do
        subject{ Tengine::ResourceEc2::Provider.new }
        its(:valid?){ should be_false }
      end

      # 存在しないキーのファイル名を指定している場合、実際にアクセスする際に例外が起きますが、
      # バリデーション等ではエラーになりません。
      context "unexist access key" do
        subject{ Tengine::ResourceEc2::Provider.new(:name => "my_east-1",
            :connection_settings => {
              :access_key_file => "/unexist/access/key/file/path",
              :secret_access_key_file => "/unexist/secret/access/key/file/path"
            }) }
        it do
          begin
            subject.synchronize_physical_servers
            fail
          rescue IOError, Errno::ENOENT => e
          end
        end
      end

    end
  end

  describe 'update resources' do
    shared_examples_for "取得した内容が反映される" do
      it do
        servers = subject.physical_servers.order(:provided_id, :asc)
        west_1a = servers.first
        west_1a.provider.should == subject
        west_1a.name.should == "us-west-1a"
        west_1a.provided_id.should == "us-west-1a"
        west_1a.status.should == "available"
        west_1b = servers.last
        west_1b.provider.should == subject
        west_1b.name.should == "us-west-1b"
        west_1b.provided_id.should == "us-west-1b"
        west_1b.status.should == "available"
      end
    end


    shared_examples_for "取得したstaticな情報が反映される" do
      it do
        assert_server = lambda do |server|
          server.provided_image_id.should == "ami-11111111"
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
        servers = subject.virtual_servers.order(:provided_id, :asc).to_a
        servers.each(&assert_server)
      end
    end

    shared_examples_for "取得した名前が反映される" do
      it do
        assert_server = lambda do |server, index|
          name = "i-" + ((index + 1).to_s * 8)
          server.name.should == name
          server.provided_id.should == name
        end
        servers = subject.virtual_servers.order(:provided_id, :asc).to_a
        servers.each_with_index(&assert_server)
      end
    end

    shared_examples_for "取得したIPとホスト名が反映される" do
      it do
        assert_server = lambda do |server, index|
          server.addresses['dns_name'].should == "ec2-184-72-203-#{index + 101}.us-west-1.compute.amazonaws.com"
          server.addresses['ip_address'].should == "184.72.20.#{index + 101}"
          server.addresses['private_dns_name'].should == "ip-10-162-153-#{index + 101}.us-west-1.compute.internal"
          server.addresses['private_ip_address'].should == "10.162.153.#{index + 101}"
        end
        servers = subject.virtual_servers.order(:provided_id, :asc).to_a
        servers.each_with_index(&assert_server)
      end
    end

    shared_examples_for "取得した状態が反映される" do
      it do
        servers = subject.virtual_servers.order(:provided_id, :asc).to_a
        servers.each do |server|
          server.status.should == "running"
        end
      end
    end

    [1, 2].each do |idx|

      subject do
        Tengine::ResourceEc2::Provider.create!(:name => "ec2-us-west-1", :connection_settings => instance_variable_get(:"@conn#{idx}"))
      end

      context "物理サーバ" do

        before do
          Tengine::Resource::PhysicalServer.delete_all
          # spec/support/ec2.rb を参照してください
          RightAws::Ec2.should_receive(:new).
            with(@access_key1, @secret_access_key1, :region => "us-west-1", :logger => Tengine.logger).
            and_return(setup_ec2_stub)
        end


        context "最初の実行時には物理サーバを登録する" do
          before do
            subject.physical_servers.count.should == 0
            subject.synchronize_physical_servers
            subject.physical_servers.count.should == 2
          end
          it_behaves_like "取得した内容が反映される"
        end

        context "すでに1台登録されている場合" do
          before do
            subject.physical_servers.create(:name => "us-west-1a", :provided_id => "us-west-1a", :status => "available")
            subject.physical_servers.count.should == 1
            subject.synchronize_physical_servers
            subject.physical_servers.count.should == 2
          end
          it_behaves_like "取得した内容が反映される"
        end

        context "すでに2台登録されている場合" do
          context "何も変わらない場合" do
            before do
              subject.physical_servers.create(:name => "us-west-1a", :provided_id => "us-west-1a", :status => "available")
              subject.physical_servers.create(:name => "us-west-1b", :provided_id => "us-west-1b", :status => "available")
              subject.physical_servers.count.should == 2
              subject.synchronize_physical_servers
              subject.physical_servers.count.should == 2
            end
            it_behaves_like "取得した内容が反映される"
          end

          context "状態が変わった場合" do
            before do
              subject.physical_servers.create(:name => "us-west-1a", :provided_id => "us-west-1a", :status => "available")
              subject.physical_servers.create(:name => "us-west-1b", :provided_id => "us-west-1b", :status => "down")
              # こんな定義はないはずですが、そもそも定義がないので。
              # http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/index.html?ApiReference-query-DescribeAvailabilityZones.html
              subject.physical_servers.count.should == 2
              subject.synchronize_physical_servers
              subject.physical_servers.count.should == 2
            end
            it_behaves_like "取得した内容が反映される"
          end

          context "nameが管理画面で変更されていた場合" do
            before do
              subject.physical_servers.create(:name => "foo", :provided_id => "us-west-1a", :status => "available")
              subject.physical_servers.create(:name => "us-west-1b", :provided_id => "us-west-1b", :status => "available")
              subject.physical_servers.count.should == 2
              subject.synchronize_physical_servers
              subject.physical_servers.count.should == 2
            end

            it do
              servers = subject.physical_servers.order(:provided_id, :asc)
              west_1a = servers.first
              west_1a.provider.should == subject
              west_1a.name.should == "foo"
              west_1a.provided_id.should == "us-west-1a"
              west_1a.status.should == "available"
              west_1b = servers.last
              west_1b.provider.should == subject
              west_1b.name.should == "us-west-1b"
              west_1b.provided_id.should == "us-west-1b"
              west_1b.status.should == "available"
            end
          end
        end

        context "すでに3台登録されている場合" do
          before do
            subject.physical_servers.create(:name => "us-west-1a", :provided_id => "us-west-1a", :status => "available")
            subject.physical_servers.create(:name => "us-west-1b", :provided_id => "us-west-1b", :status => "available")
            subject.physical_servers.create(:name => "us-west-1c", :provided_id => "us-west-1c", :status => "available")
            subject.physical_servers.count.should == 3
            subject.synchronize_physical_servers
            subject.physical_servers.count.should == 3
          end
          it "物理サーバが減るということは一大事なので、自動でデータを削除するのではなく、見つからなかったということにする" do
            servers = subject.physical_servers.order(:provided_id, :asc)
            west_1a = servers.first
            west_1a.provider.should == subject
            west_1a.name.should == "us-west-1a"
            west_1a.provided_id.should == "us-west-1a"
            west_1a.status.should == "available"
            west_1b = servers[1]
            west_1b.provider.should == subject
            west_1b.name.should == "us-west-1b"
            west_1b.provided_id.should == "us-west-1b"
            west_1b.status.should == "available"
            west_1c = servers[2]
            west_1c.provider.should == subject
            west_1c.name.should == "us-west-1c"
            west_1c.provided_id.should == "us-west-1c"
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
          @us_west_1a = subject.physical_servers.create(:name => "us-west-1a", :provided_id => "us-west-1a", :status => "available")
          @us_west_1b = subject.physical_servers.create(:name => "us-west-1b", :provided_id => "us-west-1b", :status => "available")
          @ami_1 = subject.virtual_server_images.create(:name => "ami-11111111", :provided_id => "ami-11111111")
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
            :provided_image_id => "ami-11111111",
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
              :provided_id => "i-11111111",
              :addresses => {
                :dns_name => "ec2-184-72-203-101.us-west-1.compute.amazonaws.com",
                :ip_address => "184.72.20.101",
                :private_dns_name => "ip-10-162-153-101.us-west-1.compute.internal",
                :private_ip_address => "10.162.153.101",
              }
            },
            {
              :name          => "i-22222222",
              :provided_id => "i-22222222",
              :addresses => {
                :dns_name => "ec2-184-72-203-102.us-west-1.compute.amazonaws.com",
                :ip_address => "184.72.20.102",
                :private_dns_name => "ip-10-162-153-102.us-west-1.compute.internal",
                :private_ip_address => "10.162.153.102",
              }
            },
            {
              :name          => "i-33333333",
              :provided_id => "i-33333333",
              :addresses => {
                :dns_name => "ec2-184-72-203-103.us-west-1.compute.amazonaws.com",
                :ip_address => "184.72.20.103",
                :private_dns_name => "ip-10-162-153-103.us-west-1.compute.internal",
                :private_ip_address => "10.162.153.103",
              }
            },
            {
              :name          => "i-44444444",
              :provided_id => "i-44444444",
              :addresses => {
                :dns_name => "ec2-184-72-203-104.us-west-1.compute.amazonaws.com",
                :ip_address => "184.72.20.104",
                :private_dns_name => "ip-10-162-153-104.us-west-1.compute.internal",
                :private_ip_address => "10.162.153.104",
              }
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
            with(@access_key1, @secret_access_key1, :region => "us-west-1", :logger => Tengine.logger).
            and_return(mock_ec2)
        end

        context "最初の実行時には物理サーバを登録する" do
          before do
            subject.virtual_servers.count.should == 0
            subject.synchronize_virtual_servers
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
                  :provided_id => "i-11111111",
                  :addresses => {
                    'dns_name' => "ec2-184-72-203-101.us-west-1.compute.amazonaws.com",
                    'ip_address' => "184.72.20.101",
                    'private_dns_name' => "ip-10-162-153-101.us-west-1.compute.internal",
                    'private_ip_address' => "10.162.153.101",
                  },
                }))
            subject.virtual_servers.count.should == 1
            subject.synchronize_virtual_servers
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
              subject.synchronize_virtual_servers
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
              subject.synchronize_virtual_servers
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
              subject.synchronize_virtual_servers
              subject.virtual_servers.count.should == 3
            end
            it_behaves_like "取得したstaticな情報が反映される"
            # it_behaves_like "取得した名前が反映される"
            it_behaves_like "取得したIPとホスト名が反映される"
            it_behaves_like "取得した状態が反映される"

            it "nameはTenigneで指定するものなので更新されません" do
              servers = subject.virtual_servers.order(:provided_id, :asc).to_a
              servers[0].name.should == "master1"
              servers[1].name.should == "slave1"
              servers[2].name.should == "slave2"
              servers[0].provided_id.should == "i-11111111"
              servers[1].provided_id.should == "i-22222222"
              servers[2].provided_id.should == "i-33333333"
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
            subject.synchronize_virtual_servers
            subject.reload
            subject.virtual_servers.count.should == 3
          end
          # 仮想サーバ基盤が管理している仮想サーバが減ることは通常あり得ることなので、物理サーバの場合と違ってTenigneもデータを削除する
          it_behaves_like "取得したstaticな情報が反映される"
          it_behaves_like "取得した名前が反映される"
          it_behaves_like "取得したIPとホスト名が反映される"
          it_behaves_like "取得した状態が反映される"
        end

        context "仮想マシンの起動" do
          it "1台の起動" do
            vi = subject.virtual_server_images.create(:provided_id => "ami-e444444d")
            vt = subject.virtual_server_types.create(:provided_id => "m1.small")
            vs = subject.create_virtual_servers(
              "name", vi, vt, "us-east-1b", "description", 1, 1, ["my_awesome_group"], "my_awesome_key", "", "aki-9905e0f0", "ari-8605e0ef",
              )
            vs.count.should == 1
            v = vs.first
            v.should be_valid
            v.status.should == "pending"
            v.name.should == "name001"
            v.provided_image_id.should == vi.provided_id
          end
        end

        context "仮想マシンの停止" do
          it "1台の停止" do
            vs = subject.virtual_servers.create(:provided_id => 'i-f222222d', :name => 'i-f222222d')
            va = subject.terminate_virtual_servers([vs])
            va.count.should == 1
            v = va[0]
            v.should_not be_nil
            v.should be_valid
            v.provided_id.should == 'i-f222222d'
          end

          it "複数台の停止" do
            v1 = subject.virtual_servers.create(:provided_id => 'i-f222222d', :name => 'i-f222222d')
            v2 = subject.virtual_servers.create(:provided_id => 'i-f222222e', :name => 'i-f222222e')
            va = subject.terminate_virtual_servers([v1 ,v2])
            va.count.should == 2
            va[0].should_not be_nil
            va[0].should be_valid
            va[0].provided_id.should == 'i-f222222d'
            va[1].should_not be_nil
            va[1].should be_valid
            va[1].provided_id.should == 'i-f222222e'
          end
        end
      end
    end
  end
end
