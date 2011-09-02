# -*- coding: utf-8 -*-
require 'tengine/event'
require 'eventmachine'

class Tengine::Core::Kernel

  attr_reader :config, :dsl_env

  def initialize(config)
    @config = config
  end

  def start
    bind
    if config[:tengined][:prevent_activator]
      activate
    else
      wait_for_activation
    end
  end

  def bind
    obj = Object.new
    @dsl_env = Tengine::Core::DslEnv.new
    @dsl_env.extend(Tengine::Core::DslBinder)
    @dsl_env.config = config
    @dsl_env.evaluate
  end

  def wait_for_activation
    activated = false
    activation_file_name = "#{config[:tengined][:activation_dir]}\/tengined_#{Process.pid}"
    start_time = Time.now
    while((Time.now - start_time).to_i <= config[:tengined][:activation_timeout].to_i) do
      if File.exist?(activation_file_name)
        # ファイルが見つかった
        activated = true
        break
      end
      sleep 1
    end
    if activated
      # activate開始
      activate
      File.delete(activation_file_name)
    else
      raise Tengine::Core::ActivationTimeoutError, "activation file found timeout error."
    end
  end

  def activate
    EM.run do
      # subscribe to messages in the queue
      mq.queue.subscribe(:ack => true, :nowait => true) do |headers, msg|
        # ↑のブロック引数はheadersではなくて、metadataかも。
        # headersは、metadata.headersで取得できる
        # metadata.routing_key : 
        # metadata.content_type: application/octet-stream
        # metadata.priority    : 8
        # metadata.headers     : {"coordinates"=>{"latitude"=>59.35, "longitude"=>18.066667}, "participants"=>11, "venue"=>"Stockholm"}
        # metadata.timestamp   : 2011-09-07 10:39:08 +0900
        # metadata.type        : kinda.checkin
        # metadata.delivery_tag: 1
        # metadata.redelivered : false
        # metadata.exchange    : amq.direct
        begin
          raw_event = Tengine::Event.parse(msg)
        rescue Exception => e
          puts "[#{e.class.name}] #{e.message}"
          headers.ack
          next
        end

        Tengine::Core::Event.create!(raw_event.attributes)

#         context.handlers.each do |handler|
#           begin
#             handler.process(event)
#           rescue Exception => e
#             puts "[#{e.class.name}] #{e.message}"
#             headers.ack
#             next
#           end
#         end

        headers.ack

      end
      puts "EM reactor defined"
    end
  end

  private

  def mq
    @mq ||= Tengine::Mq::Suite.new(config[:event_queue])
  end
end


class Tengine::Core::ActivationTimeoutError < StandardError
end
