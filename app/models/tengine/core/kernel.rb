# -*- coding: utf-8 -*-
require 'tengine/event'
require 'tengine/mq'
require 'eventmachine'

class Tengine::Core::Kernel

  attr_reader :config, :dsl_env, :status

  def initialize(config)
    @config = config
  end

  def start
    @status = :starting
    bind
    if config[:tengined][:skip_waiting_activation]
      activate
    else
      @status = :wait_for_activation
      wait_for_activation
    end
  end

  def stop
    if @status == :running
      @status = :stopping
      if mq.queue.default_consumer
        mq.queue.unsubscribe
        mq.connection.close{ EM.stop_event_loop } unless in_process?
      end
    else
      @status = :stopping
      # wait_for_actiontion中の処理を停止させる必要がある
    end
  end

  def in_process?
    !!@in_process
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
      File.delete(activation_file_name)
      # activate開始
      activate
    else
      @status = :stopping
      raise Tengine::Core::ActivationTimeoutError, "activation file found timeout error."
    end
  end

  def activate
    # TODO: ログ出力する
    # logger.info("activate process")
    EM.run do
      # queueへの接続までできたら稼働中（仮）
      @status = :running if mq.queue

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

        @in_process = true
        begin
          raw_event = Tengine::Event.parse(msg)
        rescue Exception => e
          puts "[#{e.class.name}] #{e.message}"
          headers.ack
          next
        end

        # 受信したイベントを登録
        event = Tengine::Core::Event.create!(raw_event.attributes)
        # TODO: ログ出力する
        # logger.info("receive a event \"#{event.event_type_name}\" key:#{event.key}")
        # puts("receive a event \"#{event.event_type_name}\" key:#{event.key}")

        # イベントハンドラの取得
        Tengine::Core::HandlerPath.default_driver_version = config.dsl_version
        handlers = Tengine::Core::HandlerPath.find_handlers(event.event_type_name)
        handlers.each do |handler|
          begin
            # block の取得
            blocks = dsl_env.blocks_for(handler.id)
            # イベントハンドラへのディスパッチ
            # TODO: ログ出力する
            # logger.info("dispatching the event key:#{event.key} to #{handler.inspect}")
            # puts("dispatching the event key:#{event.key} to #{handler.inspect}")
            handler.process_event(event, blocks)
          rescue Exception => e
            puts "[#{e.class.name}] #{e.message}"
            headers.ack
            next
          end
        end

        headers.ack

        # unsubscribed されている場合は安全な停止を行う
        unless mq.queue.default_consumer
          # TODO: loggerへ
          # puts "connection closing..."
          mq.connection.close{ EM.stop_event_loop }
        end
        @in_process = false
      end
      # puts "EM reactor defined"
    end
  end

  # 自動でログ出力する
  extend Tengine::Core::MethodTraceable
  method_trace(:start, :stop, :bind, :wait_for_activation, :activate)

  private

  def mq
    @mq ||= Tengine::Mq::Suite.new(config[:event_queue])
  end
end


class Tengine::Core::ActivationTimeoutError < StandardError
end

