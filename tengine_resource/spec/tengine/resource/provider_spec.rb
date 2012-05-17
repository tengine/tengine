# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::Provider do
  before do
    @original_locale, I18n.locale = I18n.locale, :en
  end
  after do
    I18n.locale = @original_locale
  end

  valid_attributes1 = {
    :name => "provider1"
  }.freeze

  context "nameは必須" do
    it "正常系" do
      Tengine::Resource::Provider.delete_all
      credential1 = Tengine::Resource::Provider.new(valid_attributes1)
      credential1.valid?.should == true
    end

    [:name].each do |key|
      it "#{key}なし" do
        attrs = valid_attributes1.dup
        attrs.delete(key)
        credential1 = Tengine::Resource::Provider.new(attrs)
        credential1.valid?.should == false
      end
    end

  end

  context "nameはユニーク" do
    before do
      Tengine::Resource::Provider.delete_all
      @credential1 = Tengine::Resource::Provider.create!(valid_attributes1)
    end

    it "同じ名前で登録されているものが存在する場合エラー" do
      expect{
        @credential1 = Tengine::Resource::Provider.create!(valid_attributes1)
      }.to raise_error(Mongoid::Errors::Validations, "Validation failed - Name is already taken.")
    end
  end

  context "nameはベース名として定義される文字列です" do
    it "スラッシュ'/’はリソース識別子で使われるのでnameには使用できません" do
      server1 = Tengine::Resource::Provider.new(:name => "foo/bar")
      server1.valid?.should == false
      server1.errors[:name].should == [Tengine::Core::Validation::BASE_NAME.message]
    end

    it "コロン':'はリソース識別子で使われるのでnameには使用できません" do
      server1 = Tengine::Resource::Provider.new(:name => "foo:bar")
      server1.valid?.should == false
      server1.errors[:name].should == [Tengine::Core::Validation::BASE_NAME.message]
    end
  end

  context "nameで検索" do
    before do
      Tengine::Resource::Provider.delete_all
      @fixture = GokuAtEc2ApNortheast.new
      @provider1 = @fixture.provider
    end

    context "見つかる場合" do
      it "find_by_name" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::Provider.find_by_name(@provider1.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @provider1.id
      end

      it "find_by_name!" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::Provider.find_by_name!(@provider1.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @provider1.id
      end
    end

    context "見つからない場合" do
      it "find_by_name" do
        found_credential = Tengine::Resource::Provider.find_by_name("unexist_name").should == nil
      end

      it "find_by_name!" do
        lambda{
          found_credential = Tengine::Resource::Provider.find_by_name!("unexist_name")
        }.should raise_error(Tengine::Core::FindByName::Error)
      end
    end

  end


  describe "<BUG>仮想サーバ起動画面から仮想サーバを起動すると仮想サーバが２重に登録され、仮想サーバ一覧でも２つ表示される" do
    {
      # 現在のtamaのテストモードでは、host_nodを指定していても指定しなくてもaws_availability_zoneを返さないので
      # 以下の２つのテスト用ファイルによって返されるレスポンスは同じになってしまいますが、せっかく書いたので、将来のために残しておきます
      '41_run_instances_1_virtual_servers.json' => "aws_availability_zoneが返ってくる場合",
      '43_run_instances_1_virtual_servers_without_aws_availability_zone.json' => "aws_availability_zoneが空文字列"
    }.each do |run_instance_file, msg|
      context msg do

    before do
      Tengine::Resource::PhysicalServer.delete_all
      Tengine::Resource::VirtualServer.delete_all
      Tengine::Resource::Provider.delete_all
      test_files_dir = File.expand_path("test_files", File.dirname(__FILE__))
      @provider = Tengine::Resource::Provider::Wakame.create!(:name => "Wakame",
        :connection_settings => {
          :test => true,
          :options => {
            # :describe_instance_specs_file => File.expand_path('describe_instance_specs.json', test_files_dir)  # 仮想サーバスペックの状態
            # :describe_images_file         => File.expand_path('describe_images.json',         test_files_dir), # 仮想サーバイメージの状態
            # :terminate_instances_file     => File.expand_path('terminate_instances.json',     test_files_dir), # 仮想サーバ停止時
            # :describe_host_nodes_file     => File.expand_path('describe_host_nodes.json',     test_files_dir), # 物理サーバの状態
            # 仮想サーバを一台だけ起動して、describe_instancesもその情報を返す
            :run_instances_file           => File.expand_path(run_instance_file,           test_files_dir), # 仮想サーバ起動時
            :describe_instances_file      => File.expand_path('14_describe_instances_after_run_1_instance.json',      test_files_dir), # 仮想サーバの状態
          }
        })
      @physical_server01 = @provider.physical_servers.create!(
        :name => "physical_server_uuid_01",
        :provided_id => "physical_server_uuid_01",
        :status => "online", :cpu_core => 16, :memory_size => 1000)
    end

    it "プロバイダへのリクエスト送信直後、登録処理を行う前に、tengine_resource_watchdが登録を行ってしまうと、二重登録される" do
      expect{
        expect{
          results = @provider.create_virtual_servers(
            "test",
            mock(:server_image1, :provided_id => "img-aaaa"),
            mock(:server_type1, :provided_id => "type1"),
            @physical_server01,
            "", 1) do
            # このブロックはテスト用に使われるもので、リクエストを送った直後、データを登録する前に呼び出されます。
            @provider.virtual_server_watch # 先にtengine_resource_watchdが更新してしまう
          end
          results.each{|result| result.should_not == nil}
        }.to_not raise_error
      }.to change(Tengine::Resource::VirtualServer, :count).by(1) # 1台だけ起動される
      server1 = Tengine::Resource::VirtualServer.first(:conditions => {:provided_id => "virtual_server_uuid_91"})
      server1.host_server_id.should == @physical_server01.id
    end

    context "重複チェックを行った後に、別のプロセスなどとほとんど同時に書き込んだ場合は、バリデーションエラー／一意制約違反となるがエラーとしては扱わない" do
      [:ja, :en, nil].each do |locale|
        it "localeが#{locale.inspect}" do
          I18n.locale = locale
          expect{
            expect{
              @provider.virtual_servers.should_receive(:find).with(any_args).and_return do
                @provider.virtual_server_watch # 先にtengine_resource_watchdが更新してしまう
                0 # 「重複するものは見つからなかった」
              end
              results = @provider.create_virtual_servers(
                "test",
                mock(:server_image1, :provided_id => "img-aaaa"),
                mock(:server_type1, :provided_id => "type1"),
                @physical_server01,
                "", 1
                )
              results.each{|result| result.should_not == nil}
            }.to_not raise_error
          }.to change(Tengine::Resource::VirtualServer, :count).by(1) # 1台だけ起動される
          server1 = Tengine::Resource::VirtualServer.first(:conditions => {:provided_id => "virtual_server_uuid_91"})
          server1.host_server_id.should == @physical_server01.id
        end
      end
    end

    context "登録を行った直後に、別のプロセスなどとほとんど同時に書き込んだ場合は、バリデーションエラー／一意制約違反となるがエラーとしては扱わない" do

      instance_hash = {
        :aws_kernel_id=>"",
        :aws_launch_time=>"2011-10-18T06:51:16Z",
        :tags=>{},
        :aws_reservation_id=>"",
        :aws_owner=>"a-shpoolxx",
        :instance_lifecycle=>"",
        :block_device_mappings=>
         [{:ebs_volume_id=>"",
           :ebs_status=>"",
           :ebs_attach_time=>"",
           :ebs_delete_on_termination=>false,
           :device_name=>""}],
        :ami_launch_index=>"",
        :root_device_name=>"",
        :aws_ramdisk_id=>"",
        :aws_availability_zone=>"physical_server_uuid_01",
        :aws_groups=>nil,
        :spot_instance_request_id=>"",
        :ssh_key_name=>nil,
        :virtualization_type=>"",
        :placement_group_name=>"",
        :requester_id=>"",
        :aws_instance_id=>"virtual_server_uuid_91",
        :aws_product_codes=>[],
        :client_token=>"",
        :private_ip_address=>"192.168.2.91",
        :architecture=>"x86_64",
        :aws_state_code=>0,
        :aws_image_id=>"virtual_server_image_uuid_01",
        :root_device_type=>"",
        :ip_address=>
         "nw-data=192.168.2.91,nw-outside=172.16.0.91,nw-data_2=192.168.3.91,nw-outside_2=172.16.1.91",
        :dns_name=>
         "nw-data=jria301q.shpoolxx.vdc.local,nw-outside=jria301q.shpoolxx.vdc.public,nw-data_2=jria301q.shpoolxx.vdc.local,nw-outside_2=jria301q.shpoolxx.vdc.public",
        :monitoring_state=>"",
        :aws_instance_type=>"virtual_server_spec_uuid_01",
        :aws_state=>"running",
        :private_dns_name=>"jria301q.shpoolxx.vdc.local",
        :aws_reason=>""
      }

      [:ja, :en, nil].each do |locale|
        it "localeが#{locale.inspect}" do
          I18n.locale = locale
          @provider.stub(:partion_instances).and_return([
              [instance_hash], [], []
            ])
          @physical_server01.provided_id.should == "physical_server_uuid_01"
          expect{
            # expect{
              results = @provider.create_virtual_servers(
                "test",
                mock(:server_image1, :provided_id => "img-aaaa"),
                mock(:server_type1, :provided_id => "type1"),
                @physical_server01,
                "", 1)
              results.each{|result| result.should_not == nil}
              server1 = Tengine::Resource::VirtualServer.first(:conditions => {:provided_id => "virtual_server_uuid_91"})
            server1.host_server.should_not == nil
            server1.host_server_id.should == @physical_server01.id

              @provider.virtual_server_watch # 後からtengine_resource_watchdが更新しようとする
             # }.to_not raise_error
          }.to change(Tengine::Resource::VirtualServer, :count).by(1) # 1台だけ起動される
          server1 = Tengine::Resource::VirtualServer.first(:conditions => {:provided_id => "virtual_server_uuid_91"})
          server1.host_server_id.should == @physical_server01.id
        end
      end
    end
  end

    end
  end

end
