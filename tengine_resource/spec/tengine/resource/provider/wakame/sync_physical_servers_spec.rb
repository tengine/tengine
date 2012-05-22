# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::Provider::Wakame do
  subject do
    Tengine::Resource::Provider::Wakame.delete_all
    Tengine::Resource::Provider::Wakame.create!(
      :name => "tama_test_001",
      :connection_settings => { :test => true }
      )
  end

  context :synchronize_physical_servers do
    def setup_describe_host_node_file(filename)
      subject.connection_settings[:options] = {
        :describe_host_nodes_file => File.expand_path(filename, File.dirname(__FILE__))
      }
    end


    context "初期登録時" do
      before{ Tengine::Resource::PhysicalServer.delete_all }

      context "Wakameが0件返す場合" do
        before{ setup_describe_host_node_file("00_describe_host_nodes_0_physical_servers.json")}
        it "件数は増えない" do
          expect{
            subject.synchronize_physical_servers
          }.to_not change(Tengine::Resource::PhysicalServer, :count)
        end
      end

      context "Wakameが10件返す場合" do
        before{ setup_describe_host_node_file("01_describe_host_nodes_10_physical_servers.json")}
        it "10件増える" do
          expect{
            subject.synchronize_physical_servers
          }.to change(Tengine::Resource::PhysicalServer, :count).by(10)
          Tengine::Resource::PhysicalServer.all.each do |server|
            server.provided_id.should_not == nil
            server.name.should_not == nil
            server.provider_id.should == subject.id
          end
        end
      end
    end

    context "10件登録されているとき" do
      context "テスト用JSONと同じIDのデータが登録されている" do
        before do
          Tengine::Resource::PhysicalServer.delete_all
          subject.physical_servers.tap do |servers|
            (1..10).each do |idx|
              servers.create!(:provided_id => "physical_server_id_%02d" % idx, :name => "physical_server_name_%02d" % idx)
            end
          end
        end

        context "Wakameが0件返す場合" do
          before{ setup_describe_host_node_file("00_describe_host_nodes_0_physical_servers.json")}
          it "10件削除される" do
            expect{
              subject.synchronize_physical_servers
            }.to change(Tengine::Resource::PhysicalServer, :count).by(-10)
          end
        end

        context "Wakameが同じ10件返す場合" do
          before{ setup_describe_host_node_file("01_describe_host_nodes_10_physical_servers.json")}
          it "件数もデータも変わらず" do
            ids = Tengine::Resource::PhysicalServer.all.map(&:id).map(&:to_s).sort
            expect{
              subject.synchronize_physical_servers
            }.to_not change(Tengine::Resource::PhysicalServer, :count)
            Tengine::Resource::PhysicalServer.all.map(&:id).map(&:to_s).sort.should == ids
          end
        end
      end

      context "テスト用JSONと異なるIDのデータが登録されている" do
        before do
          Tengine::Resource::PhysicalServer.delete_all
          subject.physical_servers.tap do |servers|
            (11..20).each do |idx|
              servers.create!(:provided_id => "physical_server_id_%02d" % idx, :name => "physical_server_name_%02d" % idx)
            end
          end
        end

        context "Wakameが0件返す場合" do
          before{ setup_describe_host_node_file("00_describe_host_nodes_0_physical_servers.json")}
          it "10件削除される" do
            expect{
              subject.synchronize_physical_servers
            }.to change(Tengine::Resource::PhysicalServer, :count).by(-10)
          end
        end

        context "Wakameが同じ10件返す場合" do
          before{ setup_describe_host_node_file("01_describe_host_nodes_10_physical_servers.json")}
          it "件数は変わらないが、データは変わっている" do
            ids = Tengine::Resource::PhysicalServer.all.map(&:id).map(&:to_s).sort
            expect{
              subject.synchronize_physical_servers
            }.to_not change(Tengine::Resource::PhysicalServer, :count)
            Tengine::Resource::PhysicalServer.all.map(&:id).map(&:to_s).sort.should_not == ids
          end
        end
      end
    end

  end

end
