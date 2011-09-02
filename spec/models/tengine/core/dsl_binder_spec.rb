# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::DslBinder do

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
        @binder = Tengine::Core::DslEnv.new
        @binder.extend(Tengine::Core::DslBinder)
        @binder.config = config

        @driver = Tengine::Core::Driver.new(:name => "driver01", :version => config.dsl_version)
        @handler1 = @driver.handlers.new(:event_type_names => ["event01"])
        @driver.save!
      end

      it "イベントハンドラ定義を評価して、ドライバとハンドラを保持する" do
        @driver.handlers.count.should == 1
        @binder.evaluate
        lambda {
          @binder.should_receive(:puts).with("handler01")
          @binder.block_bindings[@handler1.id].each { |block| block.call }
        }.should_not raise_error
      end

      it "同じイベント種別で複数のハンドラが登録されていた場合にはエラーとなる" do
        @handler2 = @driver.handlers.new(:event_type_names => ["event01"])
        @driver.save!
        @driver.handlers.count.should == 2

        lambda {
          @binder.evaluate
        }.should raise_error(StandardError)
      end
    end

    context "DSLのファイルを指定しない場合" do
      before do
        config = Tengine::Core::Config.new({
            :tengined => {
              :load_path => File.expand_path('../../../../spec_dsls', File.dirname(__FILE__))
            }
        })
        @binder = Tengine::Core::DslEnv.new
        @binder.extend(Tengine::Core::DslBinder)
        @binder.config = config

        @driver1 = Tengine::Core::Driver.new(:name => "driver01", :version => config.dsl_version)
        @handler1 = @driver1.handlers.new(:event_type_names => ["event01"])
        @driver1.save!
        @driver2 = Tengine::Core::Driver.new(:name => "driver02", :version => config.dsl_version)
        @handler2_1 = @driver2.handlers.new(:event_type_names => ["event02_1"])
        @handler2_2 = @driver2.handlers.new(:event_type_names => ["event02_2"])
        @driver2.save!
        @driver3 = Tengine::Core::Driver.new(:name => "driver03", :version => config.dsl_version)
        @handler3 = @driver3.handlers.new(:event_type_names => ["event03"])
        @driver3.save!
      end

      it "イベントハンドラ定義を評価して、ドライバとハンドラを保持する" do
        @binder.evaluate

        lambda {
          @binder.should_receive(:puts).with("handler01")
          @binder.block_bindings[@handler1.id].each { |block| block.call }
        }.should_not raise_error

        lambda {
          @binder.should_receive(:puts).with("handler02_1")
          @binder.should_receive(:fire).with(:event02_2)
          @binder.block_bindings[@handler2_1.id].each { |block| block.call }
        }.should_not raise_error

        lambda {
          @binder.should_receive(:puts).with("handler03_1")
          @binder.should_receive(:puts).with("handler03_2")
          @binder.block_bindings[@handler3.id].each { |block| block.call }
        }.should_not raise_error
      end
    end
  end

end
