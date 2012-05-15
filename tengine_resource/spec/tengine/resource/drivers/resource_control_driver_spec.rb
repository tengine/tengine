# -*- coding: utf-8 -*-
__END__
require 'spec_helper'
require 'tengine/rspec'

describe 'resource_control_driver' do
  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../../../../lib/tengine/resource/drivers/resource_control_driver.rb", File.dirname(__FILE__))
  driver :resource_control_driver

  before do
    Tengine::Resource::Provider::Wakame.delete_all(:name => 'tama0001')
    @provider = Tengine::Resource::Provider::Wakame.create!(
      :name => "tama0001",
      :description => "provided by wakame / tama",
      :connection_settings => {
        :account => "a-shpoolxx",
        :ec2_host => "192.168.2.22",
        :ec2_port => 9005,
        :ec2_protocol => "https",
        :wakame_host => "192.168.2.22",
        :wakame_port => 9001,
        :wakame_protocol => "https",},
      :properties => { :key_name => "ssh-xxxxx" })
  end

  context '仮想サーバ起動リクエストイベント' do
    it "反応する" do
      vi = @provider.virtual_server_images.create!(:provided_id => "wmi-lucid5", :name => "wmi-lucid5")
      vt = @provider.virtual_server_types.create!(:provided_id => "is-small", :name => "is-small")
      ps = @provider.physical_servers.create!(:provided_id => "foo-dc", :name => "foo-dc")
      @provider.
        should_receive(:create_virtual_servers).
        with(:virtual_server_image => vi,
             :virtual_server_type => vt,
             :physical_server => ps,
             :count => 1)
      Tengine::Resource::Provider::Wakame.stub(:instantiate).with(anything).and_return(@provider)

      tengine.receive('仮想サーバ起動リクエストイベント', :properties => {
        :provider_id => @provider._id,
        :virtual_server_image_id => vi._id,
        :virtual_server_type_id => vt._id,
        :physical_server_id => ps._id,
        :count => 1,})
    end
  end

  context '仮想サーバ停止リクエストイベント' do
    before do
      Tengine::Resource::VirtualServer.delete_all
    end

    it "反応する" do
      v1 = @provider.virtual_servers.create!(:provided_id => 'i-f222222d', :name => 'i-f222222d')
      v2 = @provider.virtual_servers.create!(:provided_id => 'i-f222222e', :name => 'i-f222222e')
      @provider.
        should_receive(:terminate_virtual_servers).
        with([v1, v2])
      Tengine::Resource::Provider::Wakame.stub(:instantiate).with(anything).and_return(@provider)

      tengine.receive('仮想サーバ停止リクエストイベント', :properties => {
        :provider_id => @provider._id,
        :virtual_servers => [v1._id, v2._id] })
    end

    it "存在しない仮想サーバを停止しようとすると例外がraiseされる" do
      v1 = @provider.virtual_servers.create!(:provided_id => 'i-f222222d', :name => 'i-f222222d')
      v2 = @provider.virtual_servers.create!(:provided_id => 'i-f222222e', :name => 'i-f222222e')

      # 存在するはずの仮想サーバのデータを削除して例外を起こします
      Tengine::Resource::VirtualServer.delete_all

      begin
        tengine.receive('仮想サーバ停止リクエストイベント', :properties => {
            :provider_id => @provider._id,
            :virtual_servers => [v1._id, v2._id] })
        fail
      rescue Mongoid::Errors::DocumentNotFound => e
      end
    end
  end
end
