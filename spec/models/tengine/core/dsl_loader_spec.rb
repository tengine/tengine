# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tempfile'

describe Tengine::Core::DslLoader do

  describe :evaluate do
    context "イベントハンドラ定義のファイル名まで指定されている" do
      before do
        @config = {
          :dsl_store_path => File.expand_path('dsls'),
          :dsl_file => File.expand_path('dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__)),
        }
        @loader = Tengine::Core::DslEnv.new(@config)
        @loader.extend(Tengine::Core::DslLoader)
      end

      it "ディレクトリが $LOAD_PATH に追加されていること" do
        @loader.evaluate
        $LOAD_PATH.include?(@config[:dsl_store_path]).should be_true
      end

      it "イベントハンドラ定義がロードされていること" do
        pending "Tengine.driver 未実装"
        Tengine.should_receive(:driver).with(:driver01)
        @loader.evaluate
      end

    end

    describe "イベントハンドラの評価" do
      describe :driver do
        it "Tengine.driverが呼び出されること"
        it "DslEnvが生成されていること"
        it "driverが登録されていること"
      end
    end
  end

end
