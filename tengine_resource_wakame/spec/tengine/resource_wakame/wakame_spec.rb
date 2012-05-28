# -*- coding: utf-8 -*-
require 'spec_helper'
require 'apis/ec2'
require 'apis/wakame'
require 'controllers/controller'

describe Tengine::ResourceWakame::Provider do
  subject {
    Tengine::ResourceWakame::Provider.delete_all(:name => 'tama0001')
    Tengine::ResourceWakame::Provider.create(
      :name => "tama0001",
      :description => "provided by wakame / tama",
      :connection_settings => {
        :account => "a-shpoolxx",
        :ec2_host => "10.10.10.10",
        :ec2_port => 8000,
        :ec2_protocol => "http",
        :wakame_host => "192.168.2.22",
        :wakame_port => 9001,
        :wakame_protocol => "https",
      },
    )
  }

  context "API接続" do
    it "コネクションが生成できる" do
      expect {
        invoke_ok = false
        subject.connect do |conn|
          invoke_ok = true
        end
        invoke_ok.should be_true
      }.to_not raise_error
    end

    it "コネクションの接続でエラーが発生してもリトライできる" do
      subject.retry_on_error = true
      expect {
        invoke_ok = false
        subject.connect do |conn|
          unless invoke_ok
            invoke_ok = true
            raise Errno::ETIMEDOUT
          end
        end
        invoke_ok.should be_true
      }.to_not raise_error
    end

    it "コネクションの接続でエラーが一定回数発生する場合にはエラーにする" do
      expect {
        invoke_ok = false
        subject.connect_retry_count   = 3
        subject.connect_retry_inteval = 1
        subject.connect do |conn|
          raise Errno::ETIMEDOUT
          invoke_ok = true
        end
        invoke_ok.should be_false
      }.to raise_error
    end
  end

  # [bug] 仮想マシン停止命令発行後starting状態が表示される
  context "仮想マシン停止後の起動" do
    before do
      c = mock(::Tama::Controllers::ControllerFactory.allocate)
      ::Tama::Controllers::ControllerFactory.
        stub(:create_controller).
        with("a-shpoolxx", "10.10.10.10", 8000, "http", "192.168.2.22", 9001, "https").
        and_return(c)
      c.stub(:terminate_instances).
        with(["i-f222222d"]).
        and_return([{
            :aws_shutdown_state      => nil,
            :aws_instance_id         => "i-f222222d",
            :aws_shutdown_state_code => nil,
            :aws_prev_state          => nil,
            :aws_prev_state_code     => nil,
          }])
      c.stub(:run_instances).
        with("wmi-lucid5", 1, 1, [], "ssh-xxxxx", "", nil, "is-small", nil, nil, "foo-dc", nil).
        and_return([{
            :aws_image_id       => "wmi-lucid5",
            :aws_reason         => "",
            :aws_state_code     => "0",
            :aws_owner          => "000000000888",
            :aws_instance_id    => "i-abcdabcd",
            :aws_reservation_id => "r-aabbccdd",
            :aws_state          => "pending",
            :dns_name           => "",
            :ssh_key_name       => "ssh-xxxxxx",
            :aws_groups         => [""],
            :private_dns_name   => "",
            :aws_instance_type  => "is-small",
            :aws_launch_time    => "2008-1-1T00:00:00.000Z",
            :aws_ramdisk_id     => "",
            :aws_kernel_id      => "",
            :ami_launch_index   => "0",
            :aws_availability_zone => "",
          }])
      # キーを指定
      subject.update_attributes(:properties => {
        :key_name => "ssh-xxxxx"
      })
      Tengine::Resource::Server.delete_all
      subject.virtual_servers.create(
        :provided_id => 'i-f222222d',
        :name => 'i-f222222d',
        :status => 'running')
    end

    it "statusは変更しない" do
      # 停止
      va = subject.terminate_virtual_servers(subject.virtual_servers)
      va.count.should == 1
      v = va[0]
      v.should_not be_nil
      v.should be_valid
      v.provided_id.should == 'i-f222222d'
      v.status.should == 'running'

      vi = subject.virtual_server_images.create(:provided_id => "wmi-lucid5")
      vt = subject.virtual_server_types.create(:provided_id => "is-small")
      ps = subject.physical_servers.create(:provided_id => "foo-dc")

      # 起動
      vs = subject.create_virtual_servers("i-abcdabcd", vi, vt, ps, "description", 1)
      vs.count.should == 1
      vserver = vs.first
      vserver.should be_valid
      vserver.provided_id.should == 'i-abcdabcd'
      vserver.status.should == 'pending'
    end
  end

  context "仮想マシンの起動" do
    before do
      c = mock(::Tama::Controllers::ControllerFactory.allocate)
      ::Tama::Controllers::ControllerFactory.
        stub(:create_controller).
        with("a-shpoolxx", "10.10.10.10", 8000, "http", "192.168.2.22", 9001, "https").
        and_return(c)
      c.stub(:run_instances).
        with("wmi-lucid5", 1, 1, [], "ssh-xxxxx", "", nil, "is-small", nil, nil, "foo-dc", nil).
        and_return([{
          :aws_image_id       => "wmi-lucid5",
          :aws_reason         => "",
          :aws_state_code     => "0",
          :aws_owner          => "000000000888",
          :aws_instance_id    => "i-123f1234",
          :aws_reservation_id => "r-aabbccdd",
          :aws_state          => "pending",
          :dns_name           => "",
          :ssh_key_name       => "ssh-xxxxxx",
          :aws_groups         => [""],
          :private_dns_name   => "",
          :aws_instance_type  => "is-small",
          :aws_launch_time    => "2008-1-1T00:00:00.000Z",
          :aws_ramdisk_id     => "",
          :aws_kernel_id      => "",
          :ami_launch_index   => "0",
          :aws_availability_zone => "",
        }])
      c.stub(:run_instances).
        with("wmi-lucid6", 1, 1, [], nil, "", nil, "is-micro", nil, nil, "foo-server", nil).
        and_return([{
          :aws_image_id       => "wmi-lucid6",
          :aws_reason         => "",
          :aws_state_code     => "0",
          :aws_owner          => "000000000888",
          :aws_instance_id    => "i-123f1234",
          :aws_reservation_id => "r-aabbccdd",
          :aws_state          => "pending",
          :dns_name           => "",
          :aws_groups         => [""],
          :private_dns_name   => "",
          :aws_instance_type  => "is-micro",
          :aws_launch_time    => "2008-1-1T00:00:00.000Z",
          :aws_ramdisk_id     => "",
          :aws_kernel_id      => "",
          :ami_launch_index   => "0",
          :aws_availability_zone => "",
        }])
    end

    it "1台の起動" do
      # キーを指定
      subject.update_attributes(:properties => {
        :key_name => "ssh-xxxxx"
      })
      vi = subject.virtual_server_images.create(:provided_id => "wmi-lucid5")
      vt = subject.virtual_server_types.create(:provided_id => "is-small")
      ps = subject.physical_servers.create(:provided_id => "foo-dc")
      vs = subject.create_virtual_servers("name", vi, vt, ps, "description", 1)
      vs.count.should == 1
      v = vs.first
      v.should be_valid
      v.name.should == "name001"
      v.provided_type_id.should_not be_nil
      v.provided_type_id.should_not be_empty
    end

    it "keyがない場合の起動" do
      vi = subject.virtual_server_images.create(:provided_id => "wmi-lucid6")
      vt = subject.virtual_server_types.create(:provided_id => "is-micro")
      ps = subject.physical_servers.create(:provided_id => "foo-server")
      vs = subject.create_virtual_servers("name", vi, vt, ps, "description", 1)
      vs.count.should == 1
      v = vs.first
      v.name.should == "name001"
      v.provided_type_id.should_not be_nil
      v.provided_type_id.should_not be_empty
    end
  end

  context "仮想マシンの停止" do
    before do
      Tengine::Resource::VirtualServer.delete_all
      c = mock(::Tama::Controllers::ControllerFactory.allocate)
      ::Tama::Controllers::ControllerFactory.
        stub(:create_controller).
        with("a-shpoolxx", "10.10.10.10", 8000, "http", "192.168.2.22", 9001, "https").
        and_return(c)
      c.stub(:terminate_instances).
        with(["i-f222222d"]).
        and_return([{
         :aws_shutdown_state      => nil,
         :aws_instance_id         => "i-f222222d",
         :aws_shutdown_state_code => nil,
         :aws_prev_state          => nil,
         :aws_prev_state_code     => nil,
       }])
      c.stub(:terminate_instances).
        with(["i-f222222d", "i-f222222e"]).
        and_return([{
         :aws_shutdown_state      => nil,
         :aws_instance_id         => "i-f222222d",
         :aws_shutdown_state_code => nil,
         :aws_prev_state          => nil,
         :aws_prev_state_code     => nil,
       }, {
         :aws_shutdown_state      => nil,
         :aws_instance_id         => "i-f222222e",
         :aws_shutdown_state_code => nil,
         :aws_prev_state          => nil,
         :aws_prev_state_code     => nil,
       }])
    end

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

  context "起動可能数の算出" do
    before do
      Tengine::Resource::Server.delete_all
      t1 = subject.virtual_server_types.create(:provided_id => "t1", :caption => "t1", :cpu_cores => 1, :memory_size => 2 * 1024 * 1024 * 1024)
      t2 = subject.virtual_server_types.create(:provided_id => "t2", :caption => "t2", :cpu_cores => 1, :memory_size => 4 * 1024 * 1024 * 1024)
      t3 = subject.virtual_server_types.create(:provided_id => "t3", :caption => "t3", :cpu_cores => 2, :memory_size => 4 * 1024 * 1024 * 1024)
      t4 = subject.virtual_server_types.create(:provided_id => "t4", :caption => "t4", :cpu_cores => 2, :memory_size => 8 * 1024 * 1024 * 1024)
      t5 = subject.virtual_server_types.create(:provided_id => "t5", :caption => "t5", :cpu_cores => 4, :memory_size => 8 * 1024 * 1024 * 1024)
      t6 = subject.virtual_server_types.create(:provided_id => "t6", :caption => "t6", :cpu_cores => 6, :memory_size => 8 * 1024 * 1024 * 1024)
      physical1 = subject.physical_servers.create!(:name => "physical1", :provided_id => "server1", :status => :online, :cpu_cores => 8, :memory_size => 16 * 1024 * 1024 * 1024 )
      physical2 = subject.physical_servers.create!(:name => "physical2", :provided_id => "server2", :status => :online, :cpu_cores => 12, :memory_size => 24 * 1024 * 1024 * 1024 )
      physical3 = subject.physical_servers.create!(:name => "physical3", :provided_id => "server3", :status => :offline, :cpu_cores => 12, :memory_size => 24 * 1024 * 1024 * 1024 )
      virtual11 = subject.virtual_servers.create!(:host_server => physical1, :name => "virtual11", :provided_id => "server11", :status => :running, :provided_type_id => "t6") # 6 * 8
      virtual12 = subject.virtual_servers.create!(:host_server => physical1, :name => "virtual12", :provided_id => "server12", :status => :running, :provided_type_id => "t2") # 1 * 4
      # physical1の空き cpu = 8 - (6 + 1) = 1,   mem = 16 - (8 + 4) = 4

      virtual21 = subject.virtual_servers.create!(:host_server => physical2, :name => "virtual21", :provided_id => "server21", :status => :running, :provided_type_id => "t3") # 2 * 4
      virtual22 = subject.virtual_servers.create!(:host_server => physical2, :name => "virtual22", :provided_id => "server22", :status => :running, :provided_type_id => "t6") # 6 * 8
      # physical2の空き cpu = 12 - (2 + 6) = 4,   mem = 24 - (4 + 8) = 12
    end

    it do
      subject.capacities.should == {
        'server1' => {
          't1' => 1,
          't2' => 1,
          't3' => 0,
          't4' => 0,
          't5' => 0,
          't6' => 0,
        },
        'server2' => {
          't1' => 4,
          't2' => 3,
          't3' => 2,
          't4' => 1,
          't5' => 1,
          't6' => 0,
        },
        'server3' => {
          't1' => 0,
          't2' => 0,
          't3' => 0,
          't4' => 0,
          't5' => 0,
          't6' => 0,
        },
      }
    end

    it "https://www.pivotaltracker.com/story/show/23338711" do
      subject.virtual_servers.find_by_name("virtual11").update_attributes(:status => :terminated)
      subject.capacities['server1'].should == {
        't1' => 6,
        't2' => 3,
        't3' => 3,
        't4' => 1,
        't5' => 1,
        't6' => 1,
      }
    end

  end

end
