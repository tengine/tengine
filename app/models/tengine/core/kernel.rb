# -*- coding: utf-8 -*-
require 'tengine/event'
require 'tengine/mq'
require 'eventmachine'
require 'selectable_attr'

class Tengine::Core::Kernel
  include ::SelectableAttr::Base

  selectable_attr :status do
    entry '01', :starting, '起動中'
    entry '02', :waiting_activation, '稼働要求待ち'
    entry '03', :running, '稼働中'
    entry '04', :stopping, '停止中'
    entry '05', :stoped, '停止済'
  end

  attr_reader :config, :dsl_env, :status
  attr_writer :status

  def initialize(config)
    @config = config
    self.status_key = :stoped
  end

  def start(&block)
    self.status_key = :starting
    bind
    if config[:tengined][:wait_activation]
      self.status_key = :waiting_activation
      wait_for_activation(&block)
    else
      activate(&block)
    end
  end

  def stop
    if self.status_key == :running
      self.status_key = :stopping
      if mq.queue.default_consumer
        mq.queue.unsubscribe
        mq.connection.close{ EM.stop_event_loop } unless in_process?
      end
    else
      self.status_key = :stopping
      # wait_for_actiontion中の処理を停止させる必要がある
    end
    self.status_key = :stoped
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

  def wait_for_activation(&block)
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
      activate(&block)
    else
      self.status_key = :stopping
      raise Tengine::Core::ActivationTimeoutError, "activation file found timeout error."
    end
  end

  def activate
    EM.run do
      # queueへの接続までできたら稼働中
      self.status_key = :running if mq.queue
      subscribe_queue

      yield(mq) if block_given? # このyieldは接続テストのための処理をTengine::Core:Bootstrapが定義するのに使われます。
    end
  end

  def subscribe_queue
    # subscribe to messages in the queue
    mq.queue.subscribe(:ack => true, :nowait => true) do |headers, msg|
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
          block = dsl_env.block_for(handler)
          # イベントハンドラへのディスパッチ
          # TODO: ログ出力する
          # logger.info("dispatching the event key:#{event.key} to #{handler.inspect}")
          # puts("dispatching the event key:#{event.key} to #{handler.inspect}")
          handler.process_event(event, &block)
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
  end


  # 自動でログ出力する
  extend Tengine::Core::MethodTraceable
  method_trace(:start, :stop, :bind, :wait_for_activation, :activate, :subscribe_queue)

  private

  def mq
    @mq ||= Tengine::Mq::Suite.new(config[:event_queue])
  end
end


class Tengine::Core::ActivationTimeoutError < StandardError
end

