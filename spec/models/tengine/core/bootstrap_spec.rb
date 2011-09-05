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
            :deamon => false,
            :boot_options => []
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
            :daemon => true,
            :boot_options => ["prevent_loader", "prevent_enabler", "prevent_activator"]
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
            :deamon => false,
            :boot_options => []
          }
          bootstrap = Tengine::Core::Bootstrap.new(options)
          bootstrap.should_receive(:enable_drivers)
          bootstrap.boot
        end
      end
    end

    context :single_process_mode_on_development do
      it ":action => startで、boot_optionsに指定がない" do
        options = {
          :action => "start",
          :daemon => true,
          :boot_options => []
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
          :daemon => false,
          :boot_options => []
        }
        bootstrap = Tengine::Core::Bootstrap.new(options)
        bootstrap.should_receive(:load_dsl)
        bootstrap.should_receive(:start_kernel)
        bootstrap.boot
      end
    end
  end

  describe :load_dsl do
    it "load_dslがよばれる" do
      options = {
        :action => "load",
        :deamon => false,
        :boot_options => []
      }
      bootstrap = Tengine::Core::Bootstrap.new(options)
      @mock_dsl_env = mock(:dsl_env)
      Tengine::Core::DslEnv.should_receive(:new).with(options).and_return(@mock_dsl_env)
      @mock_dsl_env.should_receive(:extend).with(Tengine::Core::DslLoader)
      @mock_dsl_env.should_receive(:evaluate)
      bootstrap.load_dsl
    end
  end

  describe :start_kernel do
    it "start_dslがよばれる" do
      options = {
        :action => "start",
        :daemon => false,
        :boot_options => []
      }
      bootstrap = Tengine::Core::Bootstrap.new(options)
      @mock_dsl_env = mock(:dsl_env)
      Tengine::Core::DslEnv.should_receive(:new).with(options).and_return(@mock_dsl_env)
      @mock_dsl_env.should_receive(:extend).with(Tengine::Core::DslBinder)
      @mock_dsl_env.should_receive(:evaluate)

      @mock_kernel = mock(:kernel)
      Tengine::Core::Kernel.should_receive(:new).with(options).and_return(@mock_kernel)
      @mock_kernel.should_receive(:start)

      bootstrap.start_kernel
    end
    it "startオプションが省略された場合" do
      pending
    end

    it "deamon起動ではないとき" do
      pending
    end
  end

  describe :enable_drivers do

  end

  describe :default_options do
    subject{ Tengine::Core::Bootstrap }
    its(:default_options) do
      should == {
        :action                 => "start",
        :daemon                 => false,
        :boot_options           => [],
        :tengine_log_dir        => ".",
        :tengine_pid_dir        => "./tmp/tengined_pids",
        :tengine_activation_dir => "./tmp/tengined_activations",
        :db_host                => "localhost",
        :db_port                => 27017,
        :db_database            => "tengine_production",
        :mq_conn_host           => "localhost",
        :mq_conn_port           => 5672,
        :mq_exchange_name       => "tengine_event_exchange",
        :mq_exchange_type       => "direct",
        :mq_exchange_durable    => true,
        :mq_queue_name          => "tengine_event_queue",
        :mq_queue_durable       => true,
        :mq_pub_persistent      => true,
        :mq_pub_mandatory       => false
      }
    end
  end
end
