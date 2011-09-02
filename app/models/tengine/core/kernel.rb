# -*- coding: utf-8 -*-
require 'tengine/event'
require 'eventmachine'

class Tengine::Core::Kernel

  attr_reader :config, :binder

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
    @binder = Tengine::Core::DslEnv.new
    @binder.extend(Tengine::Core::DslBinder)
    @binder.config = config
    @binder.evaluate
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
    @mq ||= Tengine::Mq::Suite.
      new(config[:subscription] || DEFAULT_SUBSCRIPTION_CONFIG)
  end

  DEFAULT_SUBSCRIPTION_CONFIG = YAML.load(<<EOS)
connection:
  user: 'guest'
  pass: 'guest'
  vhost: '/'
  # timeout: nil
  logging: false
  insist: false
  host: 'localhost'
  port: 5672
exchange:
  name: "notification_exchange"
  type: fanout
  passive: false
  durable: true
  auto_delete: false
  internal: false
  nowait: true
queue:
  name: "event_queue"
  passive: false
  durable: true
  auto_delete: false
  exclusive: false
  nowait: true
  subscribe:
    ack: true
    nowait: true
    confirm: nil
EOS

end


class Tengine::Core::ActivationTimeoutError < StandardError
end
