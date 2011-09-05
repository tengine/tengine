# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::DslLoader do

  describe :evaluate do
    before do
      Tengine::Core::Driver.delete_all
      Tengine::Core::HandlerPath.delete_all
    end

    context "DSLのファイルを指定する場合" do
      before do
        config = Tengine::Core::Config.new({
            :tengined => {
              :load_path => File.expand_path('../../../../spec_dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__))
            }
        })
        @loader = Object.new
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
      end
    end

    context "DSLのファイルを指定しない場合" do
      before do
        config = Tengine::Core::Config.new({
            :tengined => {
              :load_path => File.expand_path('../../../../spec_dsls', File.dirname(__FILE__))
            }
        })
        @loader = Object.new
        @loader.extend(Tengine::Core::DslLoader)
        @loader.config = config
      end

      it "イベントハンドラ定義を評価して、ドライバとハンドラを登録する" do
        @loader.evaluate
        Tengine::Core::Driver.count.should == 3
        drivers = Tengine::Core::Driver.all
        drivers.map(&:name).sort.should == ["driver01", "driver02", "driver03"]
        drivers.each do |driver|
          driver.version.should == "20110902213500"
        end
        driver02 = Tengine::Core::Driver.where(:name => "driver02").first
        driver02.handlers.count.should == 2
        handler1, handler2 = driver02.handlers
        handler1.event_type_names.should == %w[event02_1]
        handler2.event_type_names.should == %w[event02_2]
        Tengine::Core::HandlerPath.where(:driver_id => driver02.id).count.should == 2
      end
    end
  end

end
