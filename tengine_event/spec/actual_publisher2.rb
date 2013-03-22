#!/usr/bin/env ruby
# encoding: utf-8

require 'logger'
require'eventmachine'
require 'amqp'
require'json'

__DIR__ = File.dirname(__FILE__)
base_dir = File.expand_path('..', __DIR__)

logger = Logger.new(File.expand_path("tmp/log/actual_publisher2.log", base_dir))


nest = ARGV.any?{|arg| arg =~ /^nest/ }


logger.debug("#{__FILE__}##{__LINE__}")
EM.run do

    config                   =  {
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

  logger.debug("#{__FILE__}##{__LINE__}")
  AMQP.connect(config[:connection]) do |conn|
    logger.debug("#{__FILE__}##{__LINE__}")
    id = AMQP::Channel.next_channel_id
    AMQP::Channel.new(conn, id, config[:channel]) do |ch|
      logger.debug("#{__FILE__}##{__LINE__}")
      cfg = config[:exchange].dup
      name = cfg.delete :name
      type = cfg.delete :type
      cfg.delete :publish # not needed here
      AMQP::Exchange.new ch, type.intern, name, cfg do |xchg|
        logger.debug("#{__FILE__}##{__LINE__}")

        if nest
          xchg.publish({"event_type_name" => "foo"}.to_json) do
            logger.debug("#{__FILE__}##{__LINE__}")
            xchg.publish({"event_type_name" => "bar"}.to_json) do
              logger.debug("#{__FILE__}##{__LINE__}")
              xchg.publish({"event_type_name" => "baz"}.to_json) do
                logger.debug("#{__FILE__}##{__LINE__}")
                conn.close{
                  logger.debug("#{__FILE__}##{__LINE__}")
                  EM.stop{
                    logger.debug("#{__FILE__}##{__LINE__}")
                    exit
                    logger.debug("#{__FILE__}##{__LINE__}")
                  }
                  logger.debug("#{__FILE__}##{__LINE__}")
                }
                logger.debug("#{__FILE__}##{__LINE__}")
              end
              logger.debug("#{__FILE__}##{__LINE__}")
            end
            logger.debug("#{__FILE__}##{__LINE__}")
          end
        else
          xchg.publish({"event_type_name" => "foo"}.to_json)
          # xchg.publish({"event_type_name" => "foo"}.to_json) do
          #   logger.debug("#{__FILE__}##{__LINE__}")
          # end
          logger.debug("#{__FILE__}##{__LINE__}")

          # sleep 0.1

          xchg.publish({"event_type_name" => "bar"}.to_json)

          xchg.publish({"event_type_name" => "baz"}.to_json) do
            logger.debug("#{__FILE__}##{__LINE__}")
            conn.close{
              logger.debug("#{__FILE__}##{__LINE__}")
              EM.stop{
                logger.debug("#{__FILE__}##{__LINE__}")
                exit
                logger.debug("#{__FILE__}##{__LINE__}")
              }
              logger.debug("#{__FILE__}##{__LINE__}")
            }
            logger.debug("#{__FILE__}##{__LINE__}")
          end
          # xchg.publish({"event_type_name" => "bar"}.to_json) do
          #   logger.debug("#{__FILE__}##{__LINE__}")
          # end
          logger.debug("#{__FILE__}##{__LINE__}")
        end


      end
      logger.debug("#{__FILE__}##{__LINE__}")
    end
    logger.debug("#{__FILE__}##{__LINE__}")
  end
  logger.debug("#{__FILE__}##{__LINE__}")
end
logger.debug("#{__FILE__}##{__LINE__}")
