# -*- coding: utf-8 -*-
require 'spec_helper'

require 'logger'
require'eventmachine'

# このテストは手動でrabbirmq-serverを起動する必要があります。自動化はまた後で。
describe "tengine_event", manual: true do

  before do
    system(File.expand_path("../../bin/tengine_event_sucks", __FILE__))
  end

  context "publisher and subscriber are in same process" do
    let(:logger){ Logger.new(File.expand_path("../../tmp/log/actual_spec.log", __FILE__)) }
    let(:buffer){ [] }
    let(:suite ){ Tengine::Mq::Suite.new }
    let(:sender  ){ Tengine::Event::Sender.new(logger: logger) }

    before do
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

  context "publisher is in another process" do
    let(:timeout){ 10 }
    let(:buffer){ [] }
    let(:suite ){ Tengine::Mq::Suite.new }

    before do
      EM.run do
        EM.next_tick do
          puts "now waiting 2 events in #{timeout} seconds."
        end
        EM.add_timer(timeout) { suite.stop } # timeoutを設定

        suite.subscribe do |header, payload|
          header.ack
          hash = JSON.parse(payload)
          puts hash.inspect
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
