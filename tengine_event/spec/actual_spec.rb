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

  context "publisher and subscriber are in same process" do
    let(:buffer){ [] }
    let(:suite ){ Tengine::Mq::Suite.new }
    let(:sender  ){ Tengine::Event::Sender.new(logger: logger) }

    before do
      logger.info("=" * 100)
      Tengine.logger = logger
      EM.run do
        suite.subscribe do |header, payload|
          header.ack
          hash = JSON.parse(payload)
          buffer << hash["event_type_name"]
        end

        sender.fire("foo") do
          sender.fire("bar")
          sender.stop
        end
      end
    end

    it "receives foo and bar" do
      buffer.should =~ %w[foo bar]
    end
  end

  # 環境によって失敗する割合が異なるので、多めに実行しています。 10%の環境もあれば50%の環境もあります。
  repeat = (ENV['REPEAT'] || 20).to_i
  repeat.times do |idx|
    context "publisher is in another process #{idx}/#{repeat}" do
      let(:timeout){ 10 }
      let(:buffer){ [] }
      let(:suite ){ Tengine::Mq::Suite.new }

      before do
        Tengine.logger = logger
        EM.run do
          # EM.next_tick do
          #   puts "now waiting 2 events in #{timeout} seconds."
          # end
          EM.add_timer(timeout) { suite.stop } # timeoutを設定

          suite.subscribe do |header, payload|
            header.ack
            hash = JSON.parse(payload)
            # puts hash.inspect
            buffer << hash["event_type_name"]
            suite.stop if buffer.length >= 2
          end
          cmd = File.expand_path("../actual_publisher1.rb", __FILE__)
          system(cmd)
        end
      end

      it "receives foo and bar" do
        buffer.should =~ %w[foo bar]
      end
    end
  end
end
