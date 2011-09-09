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
    describe :bind, "handlerのblockをメモリ上で保持" do
      before do
        config = Tengine::Core::Config.new({
            :tengined => {
              :load_path => File.expand_path('../../../../spec_dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__)),
            },
          })
        @kernel = Tengine::Core::Kernel.new(config)
        @driver = Tengine::Core::Driver.new(:name => "driver01", :version => config.dsl_version, :enabled => true)
        @handler1 = @driver.handlers.new(:event_type_names => ["event01"])
        @driver.save!
      end

      it "event_type_nameからblockを検索することができる" do
        @kernel.bind
        @kernel.dsl_env.blocks_for(@handler1.id).count.should == 1
      end
    end

    describe :wait_for_activation, "activate待ち" do
      before do
        config = Tengine::Core::Config.new({
            :tengined => {
              :load_path => File.expand_path('../../../../spec_dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__)),
              :wait_activation => true,
              :activation_timeout => 3,
              :activation_dir => File.expand_path('.', File.dirname(__FILE__)),
            },
          })
        @kernel = Tengine::Core::Kernel.new(config)
        @driver = Tengine::Core::Driver.new(:name => "driver01", :version => config.dsl_version, :enabled => true)
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

    describe :activate, "メッセージの受信を開始" do
      before do
        @mock_channel = mock(:channel)
        @mock_queue = mock(:queue)
        @mock_consumer = mock(:consumer)

        @header = AMQP::Header.new(@mock_channel, nil, {
            :routing_key  => "",
            :content_type => "application/octet-stream",
            :priority     => 0,
            :headers      => { },
            :timestamp    => Time.now,
            :type         => "",
            :delivery_tag => 1,
            :redelivered  => false,
            :exchange     => "tengine_event_exchange",
          })

        config = Tengine::Core::Config.new({
            :tengined => {
              :load_path => File.expand_path('../../../../spec_dsls/uc01_execute_processing_for_event.rb', File.dirname(__FILE__)),
              :wait_activation => false,
            },
          })
        @kernel = Tengine::Core::Kernel.new(config)
        @driver = Tengine::Core::Driver.new(:name => "driver01", :version => config.dsl_version, :enabled => true)
        @handler1 = @driver.handlers.new(:event_type_names => ["event01"])
        @driver.save!
        @event1 = Tengine::Core::Event.new(:event_type_name => :event01, :key => "uuid1", :sender_name => "localhost")
        @event1.save!
      end

      it "イベントの受信待ち状態になる" do
        # eventmachine と mq の mock を生成
        EM.should_receive(:run).and_yield
        mock_mq = Tengine::Mq::Suite.new(@kernel.config[:event_queue])
        Tengine::Mq::Suite.should_receive(:new).with(@kernel.config[:event_queue]).and_return(mock_mq)
        mock_mq.should_receive(:queue).twice.and_return(@mock_queue)
        # subscribe されていることを検証
        @mock_queue.should_receive(:subscribe).with(:ack => true, :nowait => true)

        # 実行
        @kernel.start
      end

      it "発火されたイベントを登録できる" do
        # eventmachine と mq の mock を生成
        EM.should_receive(:run).and_yield
        mock_mq = Tengine::Mq::Suite.new(@kernel.config[:event_queue])
        Tengine::Mq::Suite.should_receive(:new).with(@kernel.config[:event_queue]).and_return(mock_mq)
        mock_mq.should_receive(:queue).exactly(3).times.and_return(@mock_queue)
        @mock_queue.should_receive(:subscribe).with(:ack => true, :nowait => true).and_yield(@header, :message)

        # subscribe してみる
        mock_row_event = mock(:row_event)
        mock_row_event.stub!(:attributes).and_return(:event_type_name => :foo, :key => "uniq_key")
        Tengine::Event.should_receive(:parse).with(:message).and_return(mock_row_event)

        @header.should_receive(:ack)
        @mock_queue.should_receive(:default_consumer).and_return(@mock_consumer)

        # 実行
        @kernel.start
        # イベントが登録されていることを検証
        Tengine::Core::Event.where(:event_type_name => :foo).count.should == 1
      end

      it "イベント種別に対応したハンドラの処理を実行することができる" do
        # eventmachine と mq の mock を生成
        EM.should_receive(:run).and_yield
        mock_mq = Tengine::Mq::Suite.new(@kernel.config[:event_queue])
        Tengine::Mq::Suite.should_receive(:new).with(@kernel.config[:event_queue]).and_return(mock_mq)
        mock_mq.should_receive(:queue).exactly(3).times.and_return(@mock_queue)
        @mock_queue.should_receive(:subscribe).with(:ack => true, :nowait => true).and_yield(@header, :message)

        # subscribe してみる
        mock_row_event = mock(:row_event)
        mock_row_event.should_receive(:attributes).and_return(:event_type_name => :event01, :key => "uuid1")
        Tengine::Event.should_receive(:parse).with(:message).and_return(mock_row_event)
        # イベントの登録
        Tengine::Core::Event.should_receive(:create!).with(:event_type_name => :event01, :key => "uuid1").and_return(@event1)

        # ハンドラの実行を検証
        Tengine::Core::HandlerPath.should_receive(:find_handlers).with("event01").and_return([@handler1])
        @handler1.should_receive(:match?).with(@event1).and_return(true)
        @handler1.should_receive(:puts).with("handler01")

        @header.should_receive(:ack)
        @mock_queue.should_receive(:default_consumer).and_return(@mock_consumer)

        # 実行
        @kernel.start
      end
    end
  end

end
