# -*- coding: utf-8 -*-
require 'spec_helper'
require 'amqp'

describe Tengine::Core::Kernel do
  before do
    Tengine::Core::Driver.delete_all
    Tengine::Core::HandlerPath.delete_all
    Tengine::Core::Event.delete_all
  end

  describe :start do
    describe :bind do
      before do
        config = Tengine::Core::Config.new({
            :tengined => {
              :load_path => File.expand_path('../../../../spec_dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__)),
            },
          })
        @kernel = Tengine::Core::Kernel.new(config)
        @driver = Tengine::Core::Driver.new(:name => "driver01", :version => config.dsl_version)
        @handler1 = @driver.handlers.new(:event_type_names => ["event01"])
        @driver.save!
      end

      it "event_type_nameからblockを検索することができる" do
        @kernel.bind
        @kernel.binder.block_bindings[@handler1.id].count.should == 1

        lambda {
          @kernel.binder.should_receive(:puts).with("handler01")
          @kernel.binder.block_bindings[@handler1.id].each { |block| block.call }
        }.should_not raise_error
      end
    end

    describe :wait_for_activation do
      before do
        config = Tengine::Core::Config.new({
            :tengined => {
              :load_path => File.expand_path('../../../../spec_dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__)),
              :activation_timeout => 3,
              :activation_dir => File.expand_path('.', File.dirname(__FILE__)),
            },
          })
        @kernel = Tengine::Core::Kernel.new(config)
        @driver = Tengine::Core::Driver.new(:name => "driver01", :version => config.dsl_version)
        @handler1 = @driver.handlers.new(:event_type_names => ["event01"])
        @driver.save!
      end

      after do
        FileUtils.rm_f("#{@kernel.config[:tengined][:activation_dir]}\/tengined_#{Process.pid}")
      end

      it "activationファイルが生成されたらactivateされる" do
        @kernel.should_receive(:activate)
        t1 = Thread.new {
          @kernel.start
        }
        t2 = Thread.new {
          FileUtils.touch("#{@kernel.config[:tengined][:activation_dir]}\/tengined_#{Process.pid}")
        }
        t1.join
        t2.join
      end

      it "activationファイルが生成されないままならタイムアウトになる" do
        lambda {
          @kernel.should_not_receive(:activate)
          @kernel.start
        }.should raise_error(Tengine::Core::ActivationTimeoutError, "activation file found timeout error.")
      end
    end

  end
end
