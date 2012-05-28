# -*- coding: utf-8 -*-
require 'spec_helper'
require 'eventmachine'
require 'amqp'
require 'tengine/mq/suite'
require 'apis/wakame'
require 'controllers/controller'

describe Tengine::Resource::Provider::Wakame do

  before :all do
    class Tengine::Resource::VirtualServerType
      def destroy; $stdout.puts "invoked"; super; end
    end
    class Tengine::Resource::VirtualServerImage
      def destroy; $stdout.puts "invoked"; super; end
    end
    class Tengine::Resource::PhysicalServer
      def destroy; $stdout.puts "invoked"; super; end
    end
    class Tengine::Resource::VirtualServer
      def destroy; $stdout.puts "invoked"; super; end
    end
  end

  after :all do
    Tengine::Resource::VirtualServerType.class_eval  { remove_method :destroy }
    Tengine::Resource::VirtualServerImage.class_eval { remove_method :destroy }
    Tengine::Resource::PhysicalServer.class_eval     { remove_method :destroy }
    Tengine::Resource::VirtualServer.class_eval      { remove_method :destroy }
  end

  before do
    Tengine::Resource::Provider.delete_all
    @provider_wakame = Tengine::Resource::Provider::Wakame.create!({
        :name => "wakame-vdc",
        :description => "",
        :properties => {
          :key_name => "ssh-xxxxx"
        },
        :polling_interval => 5,
        :connection_settings => {
          :account => "tama_account1",
          :ec2_host => "10.10.10.10",
          :ec2_port => 80,
          :ec2_protocol => "https",
          :wakame_host => "192.168.0.10",
          :wakame_port => 8080,
          :wakame_protocol => "http",
        },
      })
    Tengine::Resource::VirtualServerType.delete_all
    @virtual_server_type_wakame = @provider_wakame.virtual_server_types.create!({
        :provided_id => "is-demospec",
        :caption => "is-demospec",
        :cpu_cores => 2,
        :memory_size => 512,
        :properties => {
          :arch => "x86_64",
          :hypervisor => "kvm",
          :account_id => "a-shpoolxx",
          :vifs => "--- \neth0: \n  :bandwidth: 100000\n  :index: 0\n",
          :quota_weight => "1.0",
          :drives => "--- \nephemeral1: \n  :type: :local\n  :size: 100\n  :index: 0\n",
          :created_at => "2011-10-28T02:58:57Z",
          :updated_at => "2011-10-28T02:58:57Z",
        }
      })
    Tengine::Resource::VirtualServerImage.delete_all
    @virtual_server_image_wakame = @provider_wakame.virtual_server_images.create!({
        :name => "vimage",
        :description => "",
        :provided_id => "wmi-lucid6",
        :provided_description => "ubuntu-10.04_with-metadata_kvm_i386.raw volume",
      })
    Tengine::Resource::PhysicalServer.delete_all
    @physical_server_wakame = @provider_wakame.physical_servers.create!({
        :name => "demohost",
        :description => "",
        :provided_id => "hp-demohost",
        :status => "online",
        :addresses => {},
        :address_order => [],
        :cpu_cores => 100,
        :memory_size => 400000,
        :properties => {
          :uuid => "hp-demohost",
          :account_id => "a-shpoolxx",
          :arch => "x86_64",
          :hypervisor => "kvm",
          :created_at => "2011-10-18T03:53:24Z",
          :updated_at => "2011-10-18T03:53:24Z",
        }
      })
    Tengine::Resource::VirtualServer.delete_all
    @provider_wakame.virtual_servers.create!({
        :name => "vhost",
        :description => "",
        :provided_id => "i-jria301q",
        :provided_image_id => "wmi-lucid5",
        :provided_type_id => "is-demospec",
        :host_server => @physical_server_wakame,
        :status => "running",
        :addresses => {
          "private_ip_address" => "192.168.2.188",
          "nw-data" => "192.168.2.188",
        },
        :address_order => ["private_ip_address"],
        :properties => {
          :aws_kernel_id => "",
          :aws_launch_time => "2011-10-18T06:51:16Z",
          :tags => {},
          :aws_reservation_id => "",
          :aws_owner => "a-shpoolxx",
          :instance_lifecycle => "",
          :block_device_mappings => [{
              :ebs_volume_id => "",
              :ebs_status => "",
              :ebs_attach_time => "",
              :ebs_delete_on_termination => false,
              :device_name => ""
            }],
          :ami_launch_index => "",
          :root_device_name => "",
          :aws_ramdisk_id => "",
          :aws_availability_zone => "hp-demohost",
          :aws_groups => nil,
          :spot_instance_request_id => "",
          :ssh_key_name => nil,
          :virtualization_type => "",
          :placement_group_name => "",
          :requester_id => "",
          :aws_product_codes => [],
          :client_token => "",
          :architecture => "x86_64",
          :aws_state_code => 0,
          :root_device_type => "",
          :monitoring_state => "",
          :aws_reason => ""
        }
      })

    @tama_controller_factory = mock(::Tama::Controllers::ControllerFactory.allocate)
    ::Tama::Controllers::ControllerFactory.
      stub(:create_controller).
      with("tama_account1", "10.10.10.10", 80, "https", "192.168.0.10", 8080, "http").
      and_return(@tama_controller_factory)
  end

  describe :sync_virtual_server_types do
    it "削除の通知は一度しか行われない" do
      @tama_controller_factory.stub(:describe_instance_specs).with([]).and_return([])

      # 一度も呼び出されない
      @provider_wakame.should_not_receive(:dirrefential_update_virtual_server_type_hashs)
      @provider_wakame.should_not_receive(:create_virtual_server_type_hashs)
      # 一度だけ呼び出される
      $stdout.should_receive(:puts).with("invoked").once

      3.times do
        @provider_wakame.synchronize_virtual_server_types
      end
    end
  end

  describe :sync_virtual_server_images do
    # bug [大量にTengine::Resource::VirtualServer.destroyed.tengine_resource_watchdという種別名イベントが登録されつづけている]
    it "削除の通知は一度しか行われない" do
      @tama_controller_factory.stub(:describe_instances).with([]).and_return([])

      # 一度も呼び出されない
      @provider_wakame.should_not_receive(:dirrefential_update_virtual_server_hashs)
      @provider_wakame.should_not_receive(:create_virtual_server_hashs)
      # 一度だけ呼び出される
      $stdout.should_receive(:puts).with("invoked").once

      3.times do
        @provider_wakame.synchronize_virtual_servers
      end
    end
  end

  describe :sync_virtual_server_images do
    it "削除の通知は一度しか行われない" do
      @tama_controller_factory.stub(:describe_images).with([]).and_return([])

      # 一度も呼び出されない
      @provider_wakame.should_not_receive(:dirrefential_update_virtual_server_image_hashs)
      @provider_wakame.should_not_receive(:create_virtual_server_image_hashs)
      # 一度だけ呼び出される
      $stdout.should_receive(:puts).with("invoked").once

      3.times do
        @provider_wakame.synchronize_virtual_server_images
      end
    end
  end

  describe :sync_virtual_servers do
    # bug [大量にTengine::Resource::VirtualServer.destroyed.tengine_resource_watchdという種別名イベントが登録されつづけている]
    it "削除の通知は一度しか行われない" do
      @tama_controller_factory.stub(:describe_instances).with([]).and_return([])

      # 一度も呼び出されない
      @provider_wakame.should_not_receive(:dirrefential_update_virtual_server_hashs)
      @provider_wakame.should_not_receive(:create_virtual_server_hashs)
      # 一度だけ呼び出される
      $stdout.should_receive(:puts).with("invoked").once

      3.times do
        @provider_wakame.synchronize_virtual_servers
      end
    end
  end

  describe :sync_physical_servers do
    it "削除の通知は一度しか行われない" do
      @tama_controller_factory.stub(:describe_host_nodes).with([]).and_return([])

      # 一度も呼び出されない
      @provider_wakame.should_not_receive(:dirrefential_update_physical_server_hashs)
      @provider_wakame.should_not_receive(:create_physical_server_hashs)
      # 一度だけ呼び出される
      $stdout.should_receive(:puts).with("invoked").once

      3.times do
        @provider_wakame.synchronize_physical_servers
      end
    end
  end

end
