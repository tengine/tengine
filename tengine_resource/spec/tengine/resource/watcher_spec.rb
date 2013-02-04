# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::Watcher do

  class TestProvider1 < Tengine::Resource::Provider
    field :connection_settings, :type => Hash

    # A. [Mongoidのモデルを継承した場合のコレクションの接続先DBの不一致] への対応
    # A-1. store_inによる明示的に接続先を設定することも可能
    # Tengine::Resource::Provider.collection.tap do |c|
    #   store_in collection: c.name, database: c.database.name
    # end
    #
    # A-2. collectionの呼び出しによる接続先の事前確定
    # クラス定義時にcollectionを実行することで接続先が決定されるらしいので、
    # collectionメソッドを呼び出すだけで下記の実行時の接続先データベースが
    # 異なってしまう現象を避けることができるようです。
    collection
  end

  describe :find_providers do
    before do
      Tengine::Resource::Provider.delete_all
    end

    context "no provider exist" do
        subject{ expect{ Tengine::Resource::Watcher.new.find_providers } }
        it{ should raise_error(Tengine::Resource::Watcher::ConfigurationError, "no provider found")}
    end

    context "providers exist" do
      before do
        # [Mongoidのモデルを継承した場合のコレクションの接続先DBの不一致]
        #
        # テストの実行順によってはTestProvider1とTengine::Resource::Providerの
        # コレクションのデータベースが異なってしまうことがあります。
        #
        # 具体的には
        # 1. bundle exec rspec spec/tengine/resource/watcher_spec.rb spec/tengine/resource/cli/server_spec.rb
        # 2. bundle exec rspec spec/tengine/resource/cli/server_spec.rb spec/tengine/resource/watcher_spec.rb
        # があった場合
        # 1は成功しますが、2は以下のようなエラーで失敗します。
        #
        # 1) Tengine::Resource::Watcher find_providers providers exist valid
        #    Failure/Error: Tengine::Resource::Provider.collection.database.name.to_s
        #      expected: "tengine_resource_test"
        #           got: "tengine_production" (using ==)
        #    # ./spec/tengine/resource/watcher_spec.rb:47:in `block (4 levels) in <top (required)>'
        #
        TestProvider1.collection.database.name.to_s.should == Tengine::Resource::Provider.collection.database.name.to_s

        @provider1 = TestProvider1.create!(:name => "test1", :connection_settings => {:foo => "FOO", :bar => "BAR"})
        @provider2 = TestProvider1.create!(:name => "test2", :connection_settings => {:baz => "BAZ"})
      end

      context "valid" do
        subject{ Tengine::Resource::Watcher.new.find_providers }

        its(:length){ should == 2 }
        its(:first){ should be_a(TestProvider1) }
        its(:last){ should be_a(TestProvider1) }
        it{ subject.first.id.should == @provider1.id }
        it{ subject.last.id.should == @provider2.id }
      end

      context "with provider class in unloaded package" do

        before do
          @provider_class_name = "Tengine::ResourceEc2::Provider"
          Tengine::Resource::Provider.collection.tap do |c|
            c.insert({:_id => Moped::BSON::ObjectId.new, :_type => @provider_class_name, :name => "tengine@ec2-tokyo",
                :connection_settings => {"access_key_file" => "~/.ec2/access_key", "secret_access_key_file" => "~/.ec2/secret_access_key"}})
          end
        end

        subject{ expect{ Tengine::Resource::Watcher.new.find_providers } }
        it{ should raise_error(Tengine::Resource::Watcher::ConfigurationError, "provider class not found: #{@provider_class_name}")}
      end

    end
  end

end
