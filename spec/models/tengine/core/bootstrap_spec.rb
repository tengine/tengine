# -*- coding: utf-8 -*-
require 'spec_helper'
require 'amqp'
require 'eventmachine'
require 'tengine/mq'
require 'tengine/event'

describe "Tengine::Core::Bootstrap" do

  describe "bootメソッドでは" do
    context "config[:action] => load の場合" do
      it "load_dslがよばれること" do
        options = { :action => "load" }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        bootstrap.should_receive(:load_dsl)
        bootstrap.boot
      end
    end

    context "config[:action] => start かつ skipオプションが設定されている場合" do
      it "load_dslはよばれず、start_kernelのみよばれること" do
        options = {
          :action => "start",
          :tengined => {
            :skip_load => true,
            :skip_enablement => true,
            :wait_activation => false
          }
        }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        bootstrap.should_receive(:start_kernel)
        bootstrap.should_not_receive(:load_dsl)
        bootstrap.boot
      end
    end

    context "config[:action] => status の場合" do
      it "kernel_statusがよばれること" do
        options = { :action => "status" }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        bootstrap.should_receive(:kernel_status)
        bootstrap.boot
      end
    end

    context "config[:action] => enable の場合" do
      it "enable_driversがよばれること" do
        options = { :action => "enable" }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        bootstrap.should_receive(:enable_drivers)
        bootstrap.boot
      end
    end

    context "config[:action] => startで、skipオプションの指定がない場合" do
      it "load_dslとstart_kernelがよばれること" do
        options = { :action => "start" }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        bootstrap.should_receive(:load_dsl)
        bootstrap.should_receive(:start_kernel)
        bootstrap.boot
      end
    end

    context "config[:action] => test の場合" do
      it "load_dsl, start_kernel, start_connection_test, stop_kernelがよばれること" do
        options = { :action => "test" }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        bootstrap.should_receive(:load_dsl)
        bootstrap.should_receive(:start_kernel)
        bootstrap.should_receive(:start_connection_test)
        bootstrap.should_receive(:stop_kernel)
        bootstrap.boot
      end
    end

    context "config[:action]に想定外の値が設定された場合" do
      it "ArgumentErrorをraiseする" do
        options = { :action => 1 }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        expect {
          bootstrap.boot
        }.to raise_error(ArgumentError, /config[:action] must be test|load|start|enable|stop|force-stop|status but was/)
      end
    end
  end

  describe :load_dsl do
    it "Tengine::Core::DslLoaderのevaluateがよばれる" do
      options = { :action => "load" }

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
    it "Tengine::Core::Kernel#start がよばれる" do
      options = { :action => "start" }
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

    it "enabled=true に更新される" do
      options = {
        :action => "enable",
        :tengined => { :load_path => "./" }
      }
      bootstrap = Tengine::Core::Bootstrap.new(options)
      bootstrap.boot

      Tengine::Core::Driver.where(:version => "20110905172830") do |d|
        d.enabled.should be_true
      end
    end
  end

  describe :start_connection_test do
    before do
      @config = {
        :connection => {"foo" => "aaa"},
        :exchange => {'name' => "exchange1", 'type' => 'direct', 'durable' => true},
        :queue => {'name' => "queue1", 'durable' => true},
      }
      @mq_suite = Tengine::Mq::Suite.new(@config)

      @mock_mq = mock(:amqp)
      @mock_connection = mock(:connection)
    end

    it "イベントを発火する" do
      options = { :action => "test" }

      bootstrap = Tengine::Core::Bootstrap.new(options)
      EM.should_receive(:run).and_yield
      Tengine::Event.should_receive(:fire).with(:foo, :notification_level_key => :info).and_yield

      Tengine::Event.should_receive(:mq_suite).and_return(@mock_mq)
      @mock_mq.should_receive(:connection).and_return(@mock_connection)
      @mock_connection.should_receive(:disconnect).and_yield
      EM.should_receive(:stop)
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

  describe :stop_kernel do
    it "Tengine::Core::Kernel#stop がよばれること" do
      options = { :action => "stop" }
      bootstrap = Tengine::Core::Bootstrap.new(options)

      mock_config = mock(:config)
      bootstrap.should_receive(:config).and_return(mock_config)
      mock_kernel = mock(:kernel)
      Tengine::Core::Kernel.should_receive(:new).with(mock_config).and_return(mock_kernel)
      mock_kernel.should_receive(:start)
      bootstrap.start_kernel
      mock_kernel.should_receive(:stop)
      bootstrap.stop_kernel
    end
  end

  describe :kernel_status do
  end
end
