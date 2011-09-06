# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Tengine::Core::Bootstrap" do

  before do

  end

  describe :boot do
    # 引数にoptions(Hash)をうけとる
    # options[:action]をみてload_dsl or start_kernel or enable_driversをよぶ
    context :deploy_production do
      context :load_dsl do
        it ":action => loadの場合" do
          options = {
            :action => "load",
            :tengined => {
              :deamon => false,
            }
          }
          bootstrap = Tengine::Core::Bootstrap.new(options)
          bootstrap.should_receive(:load_dsl)
          bootstrap.boot
        end
      end

      context :start_kernel do
        it ":action => startで、start_kernelのみを実行したい場合" do
          options = {
            :action => "start",
            :tengined => {
              :daemon => true,
              :prevent_loader => true,
              :prevent_enabler => true,
              :prevent_activator => true
            }
          }
          bootstrap = Tengine::Core::Bootstrap.new(options)
          bootstrap.should_receive(:start_kernel)
          bootstrap.should_not_receive(:load_dsl)
          bootstrap.boot
        end
      end

      context :enable_drivers do
        it ":action => enableの場合" do
          options = {
            :action => "enable",
            :tengined => {
              :deamon => false,
            }
          }
          bootstrap = Tengine::Core::Bootstrap.new(options)
          bootstrap.should_receive(:enable_drivers)
          bootstrap.boot
        end
      end
    end

    context :single_process_mode_on_development do
      it ":action => startで、--tengined-prevent-loaderの指定がない" do
        options = {
          :action => "start",
          :tengined => {
            :daemon => true,
          }
        }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        bootstrap.should_receive(:load_dsl)
        bootstrap.should_receive(:start_kernel)
        bootstrap.boot
      end
    end

    context :test_boot do
      it ":action => testの場合" do
        options = {
          :action => "test",
          :tengined => {
            :daemon => false,
          }
        }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        bootstrap.should_receive(:load_dsl)
        bootstrap.should_receive(:start_kernel)
        bootstrap.should_receive(:start_connection_test)
        bootstrap.should_receive(:stop_kernel)
        bootstrap.boot
      end
    end
  end

  describe :load_dsl do
    it "load_dslがよばれる" do
      options = {
        :action => "load",
        :tengined => {
          :deamon => false,
        }
      }
      bootstrap = Tengine::Core::Bootstrap.new(options)
      mock_config = mock(:config)
      bootstrap.should_receive(:config).and_return(mock_config)
      mock_dsl_dummy_env = mock(:dsl_dummy_env)
      Tengine::Core::DslDummyEnv.should_receive(:new).and_return(mock_dsl_dummy_env)
      mock_dsl_dummy_env.should_receive(:extend).with(Tengine::Core::DslLoader)
      mock_dsl_dummy_env.should_receive(:config=).with(mock_config)
      mock_dsl_dummy_env.should_receive(:evaluate)
      bootstrap.load_dsl
    end
  end

  describe :start_kernel do
    it "start_kernelがよばれる" do
      options = {
        :action => "start",
        :tengined => {
          :daemon => false,
        }
      }
      bootstrap = Tengine::Core::Bootstrap.new(options)

      mock_config = mock(:config)
      bootstrap.should_receive(:config).and_return(mock_config)
      mock_kernel = mock(:kernel)
      Tengine::Core::Kernel.should_receive(:new).with(mock_config).and_return(mock_kernel)
      mock_kernel.should_receive(:start)
      bootstrap.start_kernel
    end

  end

  describe :enable_drivers do
    before do
      Tengine::Core::Driver.delete_all
      t = Time.local(2011,9,5,17,28,30)
      Time.stub!(:now).and_return(t)

      @d1 = Tengine::Core::Driver.create!(:name=>"driver1", :version=>"20110905172830", :enabled=>false, :enabled_on_activation=>false)
      @d2 = Tengine::Core::Driver.create!(:name=>"driver2", :version=>"20110905172830", :enabled=>false, :enabled_on_activation=>false)
      @d3 = Tengine::Core::Driver.create!(:name=>"driver3", :version=>"20110905172830", :enabled=>false, :enabled_on_activation=>false)
    end

    it "enable_driversで、enabled=trueになる" do
      options = {
        :action => "enable",
        :tengined => {
          :load_path => "./"
        }
      }
      bootstrap = Tengine::Core::Bootstrap.new(options)
      bootstrap.boot

      Tengine::Core::Driver.where(:version => "20110905172830") do |d|
        d.enabled.should be_true
      end
    end
  end

  describe :start_connection_test do
    it "イベントキューにイベントを発火 " do
      options = {
        :action => "test",
      }

      bootstrap = Tengine::Core::Bootstrap.new(options)
      Tengine::Event.should_receive(:fire).with(:foo, :notification_level_key => :info)
      event = bootstrap.start_connection_test

      Tengine::Event.config[:connection][:host].should == "localhost"
      Tengine::Event.config[:connection][:port].should == 5672
      Tengine::Event.config[:exchange][:name].should == "tengine_event_exchange"
      Tengine::Event.config[:exchange][:type].should == "direct"
      Tengine::Event.config[:exchange][:durable].should be_true
      Tengine::Event.config[:queue][:name].should == "tengine_event_queue"
      Tengine::Event.config[:queue][:durable].should be_true
    end
  end
end
