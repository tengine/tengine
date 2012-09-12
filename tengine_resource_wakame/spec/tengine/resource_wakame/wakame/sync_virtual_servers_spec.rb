# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::ResourceWakame::Provider do
  subject do
    Tengine::ResourceWakame::Provider.delete_all
    Tengine::ResourceWakame::Provider.create!(
      :name => "tama_test_001",
      :connection_settings => {
        :test => true,
        :options => {
          :describe_host_nodes_file => File.expand_path("01_describe_host_nodes_10_physical_servers.json", File.dirname(__FILE__)),
          :describe_images_file => File.expand_path("21_describe_images_5_virtual_server_images.json", File.dirname(__FILE__)),
          :describe_instance_specs_file => File.expand_path("31_describe_instance_specs_4_virtual_server_specs.json", File.dirname(__FILE__)),
        }
      })
  end

  before do
    Tengine::Resource::PhysicalServer.delete_all
    Tengine::Resource::VirtualServerImage.delete_all
    Tengine::Resource::VirtualServerType.delete_all
    subject.synchronize_physical_servers
    subject.synchronize_virtual_server_images
    subject.synchronize_virtual_server_types
  end

  virtual_server_attrs = {
    "virtual_server_id_01" => {
      :provided_physical_server_id => "physical_server_id_01",
      :provided_image_id => "virtual_server_image_uuid_01",
      :provided_type_id => "virtual_server_spec_id_01",
      :name => "virtual_server_id_01"
    },
    "virtual_server_id_02" => {
      :provided_physical_server_id => "physical_server_id_01",
      :provided_image_id => "virtual_server_image_uuid_01",
      :provided_type_id => "virtual_server_spec_id_01",
      :name => "virtual_server_id_02"
    },
    "virtual_server_id_03" => {
      :provided_physical_server_id => "physical_server_id_01",
      :provided_image_id => "virtual_server_image_uuid_01",
      :provided_type_id => "virtual_server_spec_id_01",
      :name => "virtual_server_id_03"
    },
    "virtual_server_id_04" => {
      :provided_physical_server_id => "physical_server_id_01",
      :provided_image_id => "virtual_server_image_uuid_01",
      :provided_type_id => "virtual_server_spec_id_01",
      :name => "virtual_server_id_04"
    },
    "virtual_server_id_05" => {
      :provided_physical_server_id => "physical_server_id_01",
      :provided_image_id => "virtual_server_image_uuid_01",
      :provided_type_id => "virtual_server_spec_id_01",
      :name => "virtual_server_id_05"
    },

    "virtual_server_id_06" => {
      :provided_physical_server_id => "physical_server_id_02",
      :provided_image_id => "virtual_server_image_uuid_02",
      :provided_type_id => "virtual_server_spec_id_02",
      :name => "virtual_server_id_06"
    },
    "virtual_server_id_07" => {
      :provided_physical_server_id => "physical_server_id_02",
      :provided_image_id => "virtual_server_image_uuid_02",
      :provided_type_id => "virtual_server_spec_id_02",
      :name => "virtual_server_id_07"
    },
    "virtual_server_id_08" => {
      :provided_physical_server_id => "physical_server_id_02",
      :provided_image_id => "virtual_server_image_uuid_02",
      :provided_type_id => "virtual_server_spec_id_02",
      :name => "virtual_server_id_08"
    },

    "virtual_server_id_09" => {
      :provided_physical_server_id => "physical_server_id_03",
      :provided_image_id => "virtual_server_image_uuid_01",
      :provided_type_id => "virtual_server_spec_id_01",
      :name => "virtual_server_id_09"
    },

    "virtual_server_id_10" => {
      :provided_physical_server_id => "physical_server_id_03",
      :provided_image_id => "virtual_server_image_uuid_02",
      :provided_type_id => "virtual_server_spec_id_02",
      :name => "virtual_server_id_10"
    },
  }


  context :synchronize_virtual_servers do
    def setup_describe_instances_file(filename)
      subject.connection_settings[:options] = {
        :describe_instances_file => File.expand_path(filename, File.dirname(__FILE__))
      }
    end

    context "初期登録時" do
      before{ Tengine::Resource::VirtualServer.delete_all }

      context "Wakameが0件返す場合" do
        before{ setup_describe_instances_file("10_describe_instances_0_virtual_servers.json")}
        it "件数は増えない" do
          expect{
            subject.synchronize_virtual_servers
          }.to_not change(Tengine::Resource::VirtualServer, :count)
        end
      end

      context "Wakameが10件返す場合" do
        before{ setup_describe_instances_file("11_describe_instances_10_virtual_servers.json")}
        it "10件増える" do
          expect{
            subject.synchronize_virtual_servers
          }.to change(Tengine::Resource::VirtualServer, :count).by(10)
          Tengine::Resource::VirtualServer.all(:sort => [:_id, :asc]).each_with_index do |server, idx|
            provided_id = "virtual_server_id_%02d" % (idx + 1)
            server.provided_id.should == provided_id
            expectations = virtual_server_attrs[provided_id].dup

            server.name.should == expectations[:name]
            server.provided_image_id.should == expectations[:provided_image_id]
            server.provided_type_id.should == expectations[:provided_type_id]
            server.provider_id.should == subject.id

            provided_physical_server_id = expectations.delete(:provided_physical_server_id)
            physical_server = Tengine::Resource::PhysicalServer.where({:provided_id => provided_physical_server_id}).first
            server.host_server_id.should == physical_server.id
          end
        end
      end
    end

    context "10件登録されているとき" do
      context "テスト用JSONと同じIDのデータが登録されている" do
        before do
          Tengine::Resource::VirtualServer.delete_all
          subject.virtual_servers.tap do |servers|
            (1..10).each do |idx|
              provided_id = "virtual_server_id_%02d" % idx
              attrs = virtual_server_attrs[provided_id].dup
              attrs.update(:provided_id => provided_id)


              provided_physical_server_id = attrs.delete(:provided_physical_server_id)
              raise ":provided_physical_server_id not found for #{provided_id}" unless provided_physical_server_id
              physical_server = Tengine::Resource::PhysicalServer.where({:provided_id => provided_physical_server_id}).first
              raise "physical_server not found for #{provided_physical_server_id}" unless physical_server
              attrs.update(:host_server_id => physical_server.id)

              servers.create!(attrs)
            end
          end
        end

        context "Wakameが0件返す場合" do
          before{ setup_describe_instances_file("10_describe_instances_0_virtual_servers.json")}
          it "10件削除される" do
            Tengine::Resource::VirtualServer.count.should == 10
            expect{
              subject.synchronize_virtual_servers
            }.to change(Tengine::Resource::VirtualServer, :count).by(-10)
          end
        end

        context "Wakameが同じ10件返す場合" do
          before{ setup_describe_instances_file("11_describe_instances_10_virtual_servers.json")}
          it "件数もデータも変わらず" do
            ids = Tengine::Resource::VirtualServer.all.map(&:id).map(&:to_s).sort
            expect{
              subject.synchronize_virtual_servers
            }.to_not change(Tengine::Resource::VirtualServer, :count)
            Tengine::Resource::VirtualServer.all.map(&:id).map(&:to_s).sort.should == ids
          end
        end
      end

      context "テスト用JSONと異なるIDのデータが登録されている" do
        before do
          Tengine::Resource::VirtualServer.delete_all
          subject.virtual_servers.tap do |servers|
            (11..20).each do |idx|
              servers.create!(:provided_id => "virtual_server_image_uuid_%02d" % idx, :name => "virtual_server_image_name_%02d" % idx)
            end
          end
        end

        context "Wakameが0件返す場合" do
          before{ setup_describe_instances_file("10_describe_instances_0_virtual_servers.json")}
          it "10件削除される" do
            expect{
              subject.synchronize_virtual_servers
            }.to change(Tengine::Resource::VirtualServer, :count).by(-10)
          end
        end

        context "Wakameが登録されているものとは異なる10件返す場合" do
          before{ setup_describe_instances_file("11_describe_instances_10_virtual_servers.json")}
          it "件数は変わらないが、データは変わっている" do
            ids = Tengine::Resource::VirtualServer.all.map(&:id).map(&:to_s).sort
            expect{
              subject.synchronize_virtual_servers
            }.to_not change(Tengine::Resource::VirtualServer, :count)
            Tengine::Resource::VirtualServer.all.map(&:id).map(&:to_s).sort.should_not == ids
          end
        end
      end
    end

  end

end
