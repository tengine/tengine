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

  context :virtual_server_type_watch do
    def setup_describe_instance_specs_file(filename)
      subject.connection_settings[:options] = {
        :describe_instance_specs_file => File.expand_path(filename, File.dirname(__FILE__))
      }
    end


    context "初期登録時" do
      before{ Tengine::Resource::VirtualServerType.delete_all }

      context "Wakameが0件返す場合" do
        before{ setup_describe_instance_specs_file("30_describe_instance_specs_0_virtual_server_specs.json")}
        it "件数は増えない" do
          expect{
            subject.virtual_server_type_watch
          }.to_not change(Tengine::Resource::VirtualServerType, :count)
        end
      end

      context "Wakameが4件返す場合" do
        before{ setup_describe_instance_specs_file("31_describe_instance_specs_4_virtual_server_specs.json")}
        it "4件増える" do
          expect{
            subject.virtual_server_type_watch
          }.to change(Tengine::Resource::VirtualServerType, :count).by(4)
          Tengine::Resource::VirtualServerType.all.each do |server|
            server.provided_id.should_not == nil
            server.caption.should_not == nil
            server.cpu_cores.should_not == nil
            server.memory_size.should_not == nil
            server.provider_id.should == subject.id
          end
        end
      end
    end

    context "4件登録されているとき" do
      context "テスト用JSONと同じIDのデータが登録されている" do
        before do
          Tengine::Resource::VirtualServerType.delete_all
          subject.virtual_server_types.tap do |servers|
            (1..4).each do |idx|
              servers.create!(:provided_id => "virtual_server_spec_id_%02d" % idx, :name => "virtual_server_type_id_%02d" % idx)
            end
          end
        end

        context "Wakameが0件返す場合" do
          before{ setup_describe_instance_specs_file("30_describe_instance_specs_0_virtual_server_specs.json")}
          it "4件削除される" do
            expect{
              subject.virtual_server_type_watch
            }.to change(Tengine::Resource::VirtualServerType, :count).by(-4)
          end
        end

        context "Wakameが同じ4件返す場合" do
          before{ setup_describe_instance_specs_file("31_describe_instance_specs_4_virtual_server_specs.json")}
          it "件数もデータも変わらず" do
            ids = Tengine::Resource::VirtualServerType.all.map(&:id).map(&:to_s).sort
            expect{
              subject.virtual_server_type_watch
            }.to_not change(Tengine::Resource::VirtualServerType, :count)
            Tengine::Resource::VirtualServerType.all.map(&:id).map(&:to_s).sort.should == ids
          end
        end
      end

      context "テスト用JSONと異なるIDのデータが登録されている" do
        before do
          Tengine::Resource::VirtualServerType.delete_all
          subject.virtual_server_types.tap do |servers|
            (11..14).each do |idx|
              servers.create!(:provided_id => "virtual_server_spec_id_%02d" % idx, :name => "virtual_server_type_name_%02d" % idx)
            end
          end
        end

        context "Wakameが0件返す場合" do
          before{ setup_describe_instance_specs_file("30_describe_instance_specs_0_virtual_server_specs.json")}
          it "4件削除される" do
            expect{
              subject.virtual_server_type_watch
            }.to change(Tengine::Resource::VirtualServerType, :count).by(-4)
          end
        end

        context "Wakameが登録されているものとは異なる4件返す場合" do
          before{ setup_describe_instance_specs_file("31_describe_instance_specs_4_virtual_server_specs.json")}
          it "件数は変わらないが、データは変わっている" do
            ids = Tengine::Resource::VirtualServerType.all.map(&:id).map(&:to_s).sort
            expect{
              subject.virtual_server_type_watch
            }.to_not change(Tengine::Resource::VirtualServerType, :count)
            Tengine::Resource::VirtualServerType.all.map(&:id).map(&:to_s).sort.should_not == ids
          end
        end
      end
    end

  end

end
