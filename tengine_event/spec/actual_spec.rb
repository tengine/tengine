# -*- coding: utf-8 -*-
require 'spec_helper'

require 'logger'
require'eventmachine'

describe "tengine_event" do

  before(:all) do
    TestRabbitmq.kill_remain_processes
    @test_rabbitmq = TestRabbitmq.new(keep_port: true).launch
  end

  after(:all) do
    TestRabbitmq.kill_launched_processes
  end

  before do
    system(File.expand_path("../../bin/tengine_event_sucks", __FILE__))
  end

  let(:logger){ Logger.new(File.expand_path("../../tmp/log/actual_spec.log", __FILE__)) }

  before{ logger.info("-" * 100) }
  after(:all){ logger.info("=" * 100) }

  shared_examples_for "publisher and subscriber are in same process" do |block|
    let(:buffer){ [] }
    let(:suite ){ Tengine::Mq::Suite.new }
    let(:sender  ){ Tengine::Event::Sender.new(logger: logger, sender: { keep_connection: true}) }

    before do
      logger.info("=" * 100)
      Tengine.logger = logger
      EM.run_test(timeout: 60) do # 1分はかからないと思うんだけど・・・
        suite.subscribe do |header, payload|
          header.ack
          hash = JSON.parse(payload)
          buffer << hash["event_type_name"]
        end
        block.call(sender)
        EM.add_timer(10){ suite.stop }
      end
    end

    it "receives foo, bar and baz" do
      buffer.should =~ %w[foo bar baz]
    end
  end

  context "sequential call" do
    it_should_behave_like "publisher and subscriber are in same process", ->(sender){
      sender.fire("foo")
      sender.fire("bar")
      sender.fire("baz")
    }
  end

  context "nested call" do
    it_should_behave_like "publisher and subscriber are in same process", ->(sender){
      sender.fire("foo") do
        sender.fire("bar") do
          sender.fire("baz")
        end
      end
    }
  end

  # ２つのイベント発火の場合には失敗したり成功したりが混じっていましたが、
  # ３つのイベント発火の場合には100%失敗するので繰り返しは1回だけでOKです。
  repeat = (ENV['REPEAT'] || 1).to_i
  repeat.times do |idx|
    context "#{idx + 1}/#{repeat} publisher is in another process" do
      let(:timeout){ 10 }
      let(:buffer){ [] }
      let(:suite ){ Tengine::Mq::Suite.new }

      before do
        Tengine.logger = logger
        EM.run_test do
          # EM.next_tick do
          #   puts "now waiting 2 events in #{timeout} seconds."
          # end
          EM.add_timer(timeout) { suite.stop } # timeoutを設定

          suite.subscribe do |header, payload|
            header.ack
            hash = JSON.parse(payload)
            # puts hash.inspect
            buffer << hash["event_type_name"]
            suite.stop if buffer.length >= 3
          end
          cmd = File.expand_path("../actual_publisher1.rb", __FILE__)
          system(cmd)
        end
      end

      it "receives foo, bar and baz", skip_travis: true do
        buffer.should =~ %w[foo bar baz]
      end
    end
  end
end
