# -*- coding: utf-8 -*-
require 'spec_helper'

require 'logger'
require 'eventmachine'
require 'amqp'
require'json'

# このテストは手動でrabbirmq-serverを起動する必要があります。自動化はまた後で。
describe "amqp", manual: true do
  let(:logger){ Logger.new(File.expand_path("../../tmp/log/amqp_spec.log", __FILE__)) }

  before do
    system(File.expand_path("../../bin/tengine_event_sucks", __FILE__))
  end

  before{ logger.debug("-" * 100) }
  after(:all){ logger.debug("=" * 100) }

  [
    "actual_publisher1.rb",
    "actual_publisher2.rb",
    "actual_publisher2.rb nest",
  ].each do |publisher_command|

    context "publisher is in another process with #{publisher_command}" do
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
        EM.run do
          EM.next_tick do
            puts "now waiting 2 events in #{timeout} seconds."
          end
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
                      puts b
                      hash = JSON.parse(b)
                      buffer << hash["event_type_name"]
                      EM.stop if buffer.length > 1
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

      it "receives foo and bar" do
        buffer.should == %w[foo bar]
      end
    end
  end

end
