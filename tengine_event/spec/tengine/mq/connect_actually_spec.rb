# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'amqp'

config_filepath = File.expand_path("../../mq_config.yml", File.dirname(__FILE__))

if File.exist?(config_filepath) && (ENV['TENGINE_EVENT_MQ_TEST'] =~ /true|on/i)
  describe "Tengine::Mq::Suite" do
    before do
      # キューをsubscribeすることで、キューを作ります
      @config = YAML.load_file(config_filepath)
      EM.run_test do
        @mq_suite = Tengine::Mq::Suite.new(@config)
        @mq_suite.queue.subscribe do |metadata, msg|
          # 何もしません
        end
        EM.add_timer(1) do
          @mq_suite.connection.close{ EM.stop_event_loop }
        end
      end
    end

    it "EM.run{...} を複数回実行できる" do
      EM.run_test{
        @mq_suite.exchange.publish("foo"){
          @mq_suite.connection.close{ EM.stop_event_loop }
        }
      }
      EM.run_test{
        @mq_suite.exchange.publish("foo"){
          @mq_suite.connection.close{ EM.stop_event_loop }
        }
      }
    end

  end
end
