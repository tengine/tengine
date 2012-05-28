# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::ResourceWakame::Provider do
  subject do
    Tengine::ResourceWakame::Provider.delete_all
    Tengine::ResourceWakame::Provider.create!(
      :name => "tama_test_001",
      :connection_settings => { :test => true }
      )
  end

  context :synchronize_virtual_server_images do
    def setup_describe_images_file(filename)
      subject.connection_settings[:options] = {
        :describe_images_file => File.expand_path(filename, File.dirname(__FILE__))
      }
    end


    context "初期登録時" do
      before{ Tengine::Resource::VirtualServerImage.delete_all }

      context "Wakameが0件返す場合" do
        before{ setup_describe_images_file("20_describe_images_0_virtual_server_images.json")}
        it "件数は増えない" do
          expect{
            subject.synchronize_virtual_server_images
          }.to_not change(Tengine::Resource::VirtualServerImage, :count)
        end
      end

      context "Wakameが5件返す場合" do
        before{ setup_describe_images_file("21_describe_images_5_virtual_server_images.json")}
        it "5件増える" do
          expect{
            subject.synchronize_virtual_server_images
          }.to change(Tengine::Resource::VirtualServerImage, :count).by(5)
          Tengine::Resource::VirtualServerImage.all.each do |server|
            server.provided_id.should_not == nil
            server.name.should_not == nil
            server.provider_id.should == subject.id
          end
        end
      end
    end

    context "5件登録されているとき" do
      context "テスト用JSONと同じIDのデータが登録されている" do
        before do
          Tengine::Resource::VirtualServerImage.delete_all
          subject.virtual_server_images.tap do |servers|
            (1..5).each do |idx|
              # TODO virtual_server_image_uuid_ ではなくて、 virtual_server_image_id_ では？
              servers.create!(:provided_id => "virtual_server_image_uuid_%02d" % idx, :name => "virtual_server_image_id_%02d" % idx)
            end
          end
        end

        context "Wakameが0件返す場合" do
          before{ setup_describe_images_file("20_describe_images_0_virtual_server_images.json")}
          it "5件削除される" do
            expect{
              subject.synchronize_virtual_server_images
            }.to change(Tengine::Resource::VirtualServerImage, :count).by(-5)
          end
        end

        context "Wakameが同じ5件返す場合" do
          before{ setup_describe_images_file("21_describe_images_5_virtual_server_images.json")}
          it "件数もデータも変わらず" do
            ids = Tengine::Resource::VirtualServerImage.all.map(&:id).map(&:to_s).sort
            expect{
              subject.synchronize_virtual_server_images
            }.to_not change(Tengine::Resource::VirtualServerImage, :count)
            Tengine::Resource::VirtualServerImage.all.map(&:id).map(&:to_s).sort.should == ids
          end
        end
      end

      context "テスト用JSONと異なるIDのデータが登録されている" do
        before do
          Tengine::Resource::VirtualServerImage.delete_all
          subject.virtual_server_images.tap do |servers|
            (11..15).each do |idx|
              # TODO virtual_server_image_uuid_ ではなくて、 virtual_server_image_id_ では？
              servers.create!(:provided_id => "virtual_server_image_uuid_%02d" % idx, :name => "virtual_server_image_name_%02d" % idx)
            end
          end
        end

        context "Wakameが0件返す場合" do
          before{ setup_describe_images_file("20_describe_images_0_virtual_server_images.json")}
          it "5件削除される" do
            expect{
              subject.synchronize_virtual_server_images
            }.to change(Tengine::Resource::VirtualServerImage, :count).by(-5)
          end
        end

        context "Wakameが登録されているものとは異なる5件返す場合" do
          before{ setup_describe_images_file("21_describe_images_5_virtual_server_images.json")}
          it "件数は変わらないが、データは変わっている" do
            ids = Tengine::Resource::VirtualServerImage.all.map(&:id).map(&:to_s).sort
            expect{
              subject.synchronize_virtual_server_images
            }.to_not change(Tengine::Resource::VirtualServerImage, :count)
            Tengine::Resource::VirtualServerImage.all.map(&:id).map(&:to_s).sort.should_not == ids
          end
        end
      end
    end

  end

end
