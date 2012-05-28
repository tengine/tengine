# -*- coding: utf-8 -*-
require 'spec_helper'
require 'apis/wakame'

describe Tengine::ResourceWakame::Provider do

  subject {
    Tengine::ResourceWakame::Provider.delete_all
    Tengine::ResourceWakame::Provider.create(
      :name => "wakameTest1",
      :description => "provided by wakame / tama",
      :connection_settings => {
        :test => true,
        :options => {
          # 仮想サーバの状態
          :describe_instances_file => File.join(
            File.dirname(__FILE__), "./test_files/describe_instances.json"),
          # 仮想サーバイメージの状態
          :describe_images_file => File.join(
            File.dirname(__FILE__), "./test_files/describe_images.json"),
          # 仮想サーバ起動時
          :run_instances_file => File.join(
            File.dirname(__FILE__), "./test_files/run_instances.json"),
          # 仮想サーバ停止時
          :terminate_instances_file => File.join(
            File.dirname(__FILE__), "./test_files/terminate_instances.json"),
          # 物理サーバの状態
          :describe_host_nodes_file  => File.join(
            File.dirname(__FILE__), "./test_files/describe_host_nodes.json"),
          # 仮想サーバスペックの状態
          :describe_instance_specs_file => File.join(
            File.dirname(__FILE__), "./test_files/describe_instance_specs.json"),
        }
      })
  }

  describe "test mode" do
    context "to_string" do
      it "仮想サーバの状態" do
        subject.describe_instances_for_api([], :convert => :string).should == [{
            "aws_kernel_id" => "",
            "aws_launch_time" => "2011-10-18T06:48:47Z",
            "tags" => {},
            "aws_reservation_id" => "",
            "aws_owner" => "a-shpoolxx",
            "instance_lifecycle" => "",
            "block_device_mappings" => [{
                "ebs_volume_id" => "",
                "ebs_status" => "",
                "ebs_attach_time" => "",
                "ebs_delete_on_termination" => false,
                "device_name" => ""
              }],
            "ami_launch_index" => "",
            "root_device_name" => "",
            "aws_ramdisk_id" => "",
            "aws_availability_zone" => "hp-testhost",
            "aws_groups" => nil,
            "spot_instance_request_id" => "",
            "ssh_key_name" => nil,
            "virtualization_type" => "",
            "placement_group_name" => "",
            "requester_id" => "",
            "aws_instance_id" => "i-9pia8e7p",
            "aws_product_codes" => [],
            "client_token" => "",
            "private_ip_address" => "192.168.2.95",
            "architecture" => "x86_64",
            "aws_state_code" => 0,
            "aws_image_id" => "wmi-lucid4",
            "root_device_type" => "",
            "ip_address" => "nw-data=192.168.2.95",
            "dns_name" => "nw-data=9pia8e7p.shpoolzz.vdc.local",
            "monitoring_state" => "",
            "aws_instance_type" => "is-testspec",
            "aws_state" => "running",
            "private_dns_name" => "9pia8e7p.shpoolzz.vdc.local",
            "aws_reason" => ""
          }]
      end

      it "仮想サーバイメージの状態" do
        subject.describe_images_for_api([], :convert => :string).should == [{
            "root_device_name" => "",
            "aws_ramdisk_id" => "",
            "block_device_mappings" => [{
                "ebs_snapshot_id" => "",
                "ebs_volume_size" => 0,
                "ebs_delete_on_termination" => false,
                "device_name" => ""
              }],
            "aws_is_public" => false,
            "virtualization_type" => "",
            "image_owner_alias" => "",
            "aws_id" => "wmi-lucid4",
            "aws_architecture" => "x86",
            "root_device_type" => "",
            "aws_location" => "--- \n:snapshot_id: snap-lucid4\n",
            "aws_image_type" => "",
            "name" => "",
            "aws_state" => "init",
            "description" => "ubuntu-10.04_with-metadata_kvm_i386.raw volume",
            "aws_kernel_id" => "",
            "tags" => {},
            "aws_owner" => "a-shpoolzz"
          }]
      end

      it "仮想サーバの起動" do
        subject.run_instances_for_api([], :convert => :string).should == [{
            "aws_launch_time" => "2011-10-18T06:48:47Z",
            "tags" => {},
            "aws_reservation_id" => "",
            "aws_owner" => "a-shpoolxx",
            "ami_launch_index" => "",
            "aws_availability_zone" => "",
            "aws_groups" => ["ng-demofgr"],
            "ssh_key_name" => nil,
            "virtualization_type" => "",
            "placement_group_name" => "",
            "aws_instance_id" => "i-9pia8e7g",
            "aws_product_codes" => [],
            "client_token" => "",
            "aws_state_code" => 0,
            "aws_image_id" => "wmi-lucid4",
            "dns_name" => nil,
            "aws_instance_type" => "is-testspec",
            "aws_state" => "scheduling",
            "private_dns_name" => nil,
            "aws_reason" => ""
          }]
      end

      it "仮想サーバの停止" do
        subject.terminate_instances_for_api([], :convert => :string).should == [{
            "aws_current_state_name" => "",
            "aws_prev_state_name" => "",
            "aws_prev_state_code" => 0,
            "aws_current_state_code" => 0,
            "aws_instance_id" => "i-9pia8e7g"
          }]
      end

      it "物理サーバの状態" do
        subject.describe_host_nodes_for_api([], :convert => :string).should == [{
            "status" => "online",
            "updated_at" => "2011-10-18T03:53:24Z",
            "account_id" => "a-shpoolzz",
            "offering_cpu_cores" => 120,
            "offering_memory_size" => 350000,
            "arch" => "x86_64",
            "hypervisor" => "kvm",
            "created_at" => "2011-10-18T03:53:24Z",
            "name" => "testhost",
            "uuid" => "hp-testhost",
            "id" => "hp-testhost"
          }]
      end

      it "仮想サーバスペックの状態" do
        subject.describe_instance_specs_for_api([], :convert => :string).should == [{
            "cpu_cores" => 2,
            "memory_size" => 512,
            "arch" => "x86_64",
            "hypervisor" => "kvm",
            "updated_at" => "2011-10-28T02:58:57Z",
            "account_id" => "a-shpoolzz",
            "vifs" => "--- \neth0: \n  :bandwidth: 100000\n  :index: 0\n",
            "quota_weight" => 1.0,
            "id" => "is-testspec",
            "created_at" => "2011-10-28T02:58:57Z",
            "drives" => "--- \nephemeral1: \n  :type: :local\n  :size: 100\n  :index: 0\n",
            "uuid" => "is-testspec"
          }]
      end
    end

    context "to_symbol" do
      it "仮想サーバの状態" do
        subject.describe_instances_for_api([], :convert => :symbol).should == [{
            :aws_kernel_id => "",
            :aws_launch_time => "2011-10-18T06:48:47Z",
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
            :aws_availability_zone => "hp-testhost",
            :aws_groups => nil,
            :spot_instance_request_id => "",
            :ssh_key_name => nil,
            :virtualization_type => "",
            :placement_group_name => "",
            :requester_id => "",
            :aws_instance_id => "i-9pia8e7p",
            :aws_product_codes => [],
            :client_token => "",
            :private_ip_address => "192.168.2.95",
            :architecture => "x86_64",
            :aws_state_code => 0,
            :aws_image_id => "wmi-lucid4",
            :root_device_type => "",
            :ip_address => "nw-data=192.168.2.95",
            :dns_name => "nw-data=9pia8e7p.shpoolzz.vdc.local",
            :monitoring_state => "",
            :aws_instance_type => "is-testspec",
            :aws_state => "running",
            :private_dns_name => "9pia8e7p.shpoolzz.vdc.local",
            :aws_reason => ""
          }]
      end

      it "仮想サーバイメージの状態" do
        subject.describe_images_for_api([], :convert => :symbol).should == [{
            :root_device_name => "",
            :aws_ramdisk_id => "",
            :block_device_mappings => [{
                :ebs_snapshot_id => "",
                :ebs_volume_size => 0,
                :ebs_delete_on_termination => false,
                :device_name => ""
              }],
            :aws_is_public => false,
            :virtualization_type => "",
            :image_owner_alias => "",
            :aws_id => "wmi-lucid4",
            :aws_architecture => "x86",
            :root_device_type => "",
            :aws_location => "--- \n:snapshot_id: snap-lucid4\n",
            :aws_image_type => "",
            :name => "",
            :aws_state => "init",
            :description => "ubuntu-10.04_with-metadata_kvm_i386.raw volume",
            :aws_kernel_id => "",
            :tags => {},
            :aws_owner => "a-shpoolzz"
          }]
      end

      it "仮想サーバの起動" do
        subject.run_instances_for_api([], :convert => :symbol).should == [{
            :aws_launch_time => "2011-10-18T06:48:47Z",
            :tags => {},
            :aws_reservation_id => "",
            :aws_owner => "a-shpoolxx",
            :ami_launch_index => "",
            :aws_availability_zone => "",
            :aws_groups => ["ng-demofgr"],
            :ssh_key_name => nil,
            :virtualization_type => "",
            :placement_group_name => "",
            :aws_instance_id => "i-9pia8e7g",
            :aws_product_codes => [],
            :client_token => "",
            :aws_state_code => 0,
            :aws_image_id => "wmi-lucid4",
            :dns_name => nil,
            :aws_instance_type => "is-testspec",
            :aws_state => "scheduling",
            :private_dns_name => nil,
            :aws_reason => ""
          }]
      end

      it "仮想サーバの停止" do
        subject.terminate_instances_for_api([], :convert => :symbol).should == [{
            :aws_current_state_name => "",
            :aws_prev_state_name => "",
            :aws_prev_state_code => 0,
            :aws_current_state_code => 0,
            :aws_instance_id => "i-9pia8e7g"
          }]
      end

      it "物理サーバの状態" do
        subject.describe_host_nodes_for_api([], :convert => :symbol).should == [{
            :status => "online",
            :updated_at => "2011-10-18T03:53:24Z",
            :account_id => "a-shpoolzz",
            :offering_cpu_cores => 120,
            :offering_memory_size => 350000,
            :arch => "x86_64",
            :hypervisor => "kvm",
            :created_at => "2011-10-18T03:53:24Z",
            :name => "testhost",
            :uuid => "hp-testhost",
            :id => "hp-testhost"
          }]
      end

      it "仮想サーバスペックの状態" do
        subject.describe_instance_specs_for_api([], :convert => :symbol).should == [{
            :cpu_cores => 2,
            :memory_size => 512,
            :arch => "x86_64",
            :hypervisor => "kvm",
            :updated_at => "2011-10-28T02:58:57Z",
            :account_id => "a-shpoolzz",
            :vifs => "--- \neth0: \n  :bandwidth: 100000\n  :index: 0\n",
            :quota_weight => 1.0,
            :id => "is-testspec",
            :created_at => "2011-10-28T02:58:57Z",
            :drives => "--- \nephemeral1: \n  :type: :local\n  :size: 100\n  :index: 0\n",
            :uuid => "is-testspec"
          }]
      end
    end

  end
end
