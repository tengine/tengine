# -*- coding: utf-8 -*-
require 'spec_helper'

require 'logger'
require 'eventmachine'
require 'amqp'
require'json'

describe "amqp" do

  before(:all) do
    TestRabbitmq.kill_remain_processes
    @test_rabbitmq = TestRabbitmq.new(keep_port: true).launch
  end
  after(:all) do
    TestRabbitmq.kill_launched_processes
  end

  let(:logger){ Logger.new(File.expand_path("../../tmp/log/amqp_spec.log", __FILE__)) }

  before do
    system(File.expand_path("../../bin/tengine_event_sucks", __FILE__))
  end

  before{ logger.debug("-" * 100) }
  after(:all){ logger.debug("=" * 100) }

  [
    "actual_publisher1.rb sequential",
    "actual_publisher1.rb nested",
    "actual_publisher2.rb sequential",
    "actual_publisher2.rb nested",
  ].each do |publisher_command|
    # ２つのイベント発火の場合には失敗したり成功したりが混じっていましたが、
    # ３つのイベント発火の場合には100%失敗するので繰り返しは1回だけでOKです。
    repeat = (ENV['REPEAT'] || 1).to_i
    repeat.times do |idx|

      context "#{idx + 1}/#{repeat} publisher is in another process with #{publisher_command}" do
        let(:timeout){ 10 }
        let(:buffer){ [] }

        let(:config) do
          {
            :sender                 => {
              :keep_connection      => false,
              :retry_interval       => 1,  # in seconds
              :retry_count          => 30,
            },
            :connection             => {
              :user                 => 'guest',
              :pass                 => 'guest',
              :vhost                => '/',
              :logging              => false,
              :insist               => false,
              :host                 => 'localhost',
              :port                 => 5672,
              :auto_reconnect_delay => 1, # in seconds
            },
            :channel                => {
              :prefetch             => 1,
              :auto_recovery        => true,
            },
            :exchange               => {
              :name                 => 'tengine_event_exchange',
              :type                 => :direct,
              :passive              => false,
              :durable              => true,
              :auto_delete          => false,
              :internal             => false,
              :nowait               => false,
              :publish              => {
                :content_type       => "application/json", # RFC4627
                :persistent         => true,
              },
            },
            :queue                  => {
              :name                 => 'tengine_event_queue',
              :passive              => false,
              :durable              => true,
              :auto_delete          => false,
              :exclusive            => false,
              :nowait               => false,
              :subscribe            => {
                :ack                => true,
                :nowait             => false,
                :confirm            => nil,
              },
            },
          }
        end

        before do
          EM.run_test do
            # EM.next_tick do
            #   puts "now waiting 2 events in #{timeout} seconds."
            # end
            EM.add_timer(timeout) { EM.stop } # timeoutを設定

            AMQP.connect(config[:connection]) do |conn|
              id = AMQP::Channel.next_channel_id
              AMQP::Channel.new(conn, id, config[:channel]) do |ch|

                cfg = config[:exchange].dup
                name = cfg.delete :name
                type = cfg.delete :type
                cfg.delete :publish # not needed here
                AMQP::Exchange.new ch, type.intern, name, cfg do |xchg|

                  cfg = config[:queue].dup
                  name = cfg.delete :name
                  ch.queue name, cfg do |que|
                    que.bind xchg, :nowait => false do

                      opts = config[:queue][:subscribe]
                      que.subscribe opts do |h, b|
                        h.ack
                        # puts b
                        hash = JSON.parse(b)
                        buffer << hash["event_type_name"]
                        conn.close{ EM.stop } if buffer.length >= 3
                      end

                    end
                  end

                end
              end
              logger.debug("#{__FILE__}##{__LINE__}")
            end
            logger.debug("#{__FILE__}##{__LINE__}")

            Process.spawn(File.expand_path("../#{publisher_command}", __FILE__))
          end
        end

        it "receives foo, bar and baz" do
          buffer.should == %w[foo bar baz]
        end
      end
    end
  end

end
