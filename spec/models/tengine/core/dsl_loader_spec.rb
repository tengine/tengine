# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::DslLoader do

  describe :evaluate do
    before do
      Tengine::Core::Driver.delete_all
      Tengine::Core::HandlerPath.delete_all
    end

    context "DSLのファイルを指定する場合" do
      context "Driverを有効化して登録(シングルプロセスモード)" do
        before do
          config = Tengine::Core::Config.new({
              :tengined => {
                :load_path => File.expand_path('../../../../spec_dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__))
              }
            })
          @loader = Tengine::Core::DslDummyEnv.new
          @loader.extend(Tengine::Core::DslLoader)
          @loader.config = config
        end

        it "イベントハンドラ定義を評価して、ドライバとハンドラを登録する" do
          @loader.evaluate
          # $LOAD_PATH.include?(@config[:dsl_store_path]).should be_true
          # driver01 = Tengine::Core::Driver.find(:conditions => {:name => "driver01"})
          Tengine::Core::Driver.count.should == 1
          driver01 = Tengine::Core::Driver.first
          driver01.should_not be_nil
          driver01.name.should == "driver01"
          driver01.version.should == "20110902213500"
          driver01.handlers.count.should == 1
          handler1 = driver01.handlers.first
          handler1.event_type_names.should == %w[event01]
          Tengine::Core::HandlerPath.where(:driver_id => driver01.id).count.should == 1
          Tengine::Core::HandlerPath.default_driver_version = "20110902213500"
          Tengine::Core::HandlerPath.find_handlers("event01").count.should == 1
        end
      end

      context "Driverを無効化して登録(マルチプロセスモード)" do
        before do
          config = Tengine::Core::Config.new({
              :tengined => {
                :load_path => File.expand_path('../../../../spec_dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__)),
                :skip_enablement => true
              }
            })
          @loader = Tengine::Core::DslDummyEnv.new
          @loader.extend(Tengine::Core::DslLoader)
          @loader.config = config
        end

        it "イベントハンドラ定義を評価して、ドライバとハンドラを登録する" do
          @loader.evaluate
          Tengine::Core::Driver.count.should == 1
          driver01 = Tengine::Core::Driver.first
          driver01.should_not be_nil
          driver01.name.should == "driver01"
          driver01.version.should == "20110902213500"
          driver01.handlers.count.should == 1
          handler1 = driver01.handlers.first
          handler1.event_type_names.should == %w[event01]
          Tengine::Core::HandlerPath.where(:driver_id => driver01.id).count.should == 1
          Tengine::Core::HandlerPath.default_driver_version = "20110902213500"
          Tengine::Core::HandlerPath.find_handlers("event01").count.should == 0
        end
      end
    end

    context "DSLのファイルを指定しない場合" do
      before do
        config = Tengine::Core::Config.new({
            :tengined => {
              :load_path => File.expand_path('../../../../spec_dsls', File.dirname(__FILE__))
            }
        })
        @loader = Tengine::Core::DslDummyEnv.new
        @loader.extend(Tengine::Core::DslLoader)
        @loader.config = config

        @loader.config.should_receive(:dsl_file_paths).and_return([
            "#{config[:tengined][:load_path]}/uc01_execute_processing_for_event.rb",
            "#{config[:tengined][:load_path]}/uc02_fire_another_event.rb",
            "#{config[:tengined][:load_path]}/uc03_2handlers_for_1event.rb",
          ])
      end

      it "イベントハンドラ定義を評価して、ドライバとハンドラを登録する" do
        # driver03にevent03が複数定義されているための警告メッセージ
        @loader.should_receive(:puts).with("[DslLoader][warn] driver\"driver03\"には、同一のevent_type_name\"event03\"が複数存在します")

        @loader.evaluate

        Tengine::Core::Driver.count.should == 3
        drivers = Tengine::Core::Driver.all
        drivers.map(&:name).sort.should == ["driver01", "driver02", "driver03"]
        drivers.each do |driver|
          driver.version.should == "20110902213500"
        end

        driver01 = Tengine::Core::Driver.where(:name => "driver01").first
        handler1 = driver01.handlers.first
        handler1.event_type_names.should == %w[event01]
        Tengine::Core::HandlerPath.where(:driver_id => driver01.id).count.should == 1

        driver02 = Tengine::Core::Driver.where(:name => "driver02").first
        driver02.handlers.count.should == 2
        handler2_1, handler2_2 = driver02.handlers
        handler2_1.event_type_names.should == %w[event02_1]
        handler2_2.event_type_names.should == %w[event02_2]
        Tengine::Core::HandlerPath.where(:driver_id => driver02.id).count.should == 2

        driver03 = Tengine::Core::Driver.where(:name => "driver03").first
        driver03.handlers.count.should == 1
        handler3 = driver03.handlers.first
        handler3.event_type_names.should == %w[event03]
        Tengine::Core::HandlerPath.where(:driver_id => driver03.id).count.should == 1
      end
    end
  end

end
