# -*- coding: utf-8 -*-
require 'tengine/event'

require 'active_support/core_ext/array/extract_options'

# MQと到達保証について by @shyouhei on 2nd Nov., 2011.
#
# 端的に言ってAMQPプロトコルにはパケットの到達保証が、ありません。したがってAMQP::Exchangeを普通に使うだけでは、fireしたイベントがどこま
# で確実に届くかが保証されません。たとえばEventMachineのリアクターが停止してしまったとか、ピアプロセスがSEGVしたとか、TCPのセッションが
# 切れてしまったとか、ハードウエアの物理線がセミの産卵で断線したとか、様々な理由でイベントはbrokerに到達しないことがありえるし、それを検
# 知する手段がありません。
#
# この問題に対してRabbitMQは、それ単体では全体の到達保証をしませんが、以下の追加手段を提供してくれています。
#
# * RabbitMQ自体の実装の努力により、RabbitMQのサーバにデータが到達して以降は、RabbitMQが到達性を保証してくれます
#
# * AMQPプロトコルを勝手に拡張していて、RabbitMQのサーバにパケットが届いたことをackしてくれるようにできます
#
# したがってAMQPブローカーにRabbitMQを使っている限りは、MQサーバにパケットが到着したことを、クライアント側でackを読みながら確認すること
# で、全体としての到達保証が可能になるわけです。
#
# Tengine::Event::Sender#fireを実行すると、イベントを送信して、このackを確認する部分までを自動的に行います。したがって所謂
# fire-and-forgetの動作が達成されています。ただし、以下のように制限があります
#
# * AMQP gemの制約上、おおむね非同期的に動作します。つまり、fireは送信を予約するだけで、実のところ送信が終わるのは(再送等で)fireが終了し
#   てからだいぶ先の話になります。
#
# * あるときだれかが EM.stop すると、それ以上はackを読めなくなり、再送信ができなくなります。
#
# * そうは言ってもEM.stopできないとプロセスが終了できないので、stop可能かどうかを調査できるようにしました(新API)。
#
#   * fireメソッドの戻り値のTengine::Eventに新メソッド #transmitted? が追加になっていますので個別のイベントの送信が終わったかどうかはこ
#     れで確認できます。
#
#   * senderが送信中のイベント一覧は sender.pending_events で入手できます
#
#   * もうsenderが送り終わったらそのままEM.stopしてよい場合(だいたいそうだと思いますが)のために、 sender.stop_after_transmission があり
#     ます
#
#   APIは今後も使い勝手のために追加する可能性があります

class Tengine::Event::Sender

  # 現在不使用。やがて消します。
  RetryError = Class.new StandardError

  attr_reader :mq_suite
  attr_reader :logger
  attr_accessor :default_keep_connection

  def initialize(*args)
    options = args.extract_options!
    config_or_mq_suite = args.first
    @mq_suite = 
      case config_or_mq_suite when Tengine::Mq::Suite then
        config_or_mq_suite
      else
        Tengine::Mq::Suite.new(options)
      end
    @default_keep_connection = @mq_suite.config[:sender][:keep_connection]
    @logger = options[:logger] || Tengine::Support::NullLogger.new
  end

  def stop(&block)
    @mq_suite.stop(&block)
  end

  # publish an event message to AMQP exchange
  # @param [String/Tengine::Event] event_or_event_type_name
  # @param [Hash] options the options for attributes
  # @option options [String] :key attriute key
  # @option options [String] :source_name source_name
  # @option options [Time] :occurred_at occurred_at
  # @option options [Integer] :level level
  # @option options [Symbol] :level_key level_key
  # @option options [String] :sender_name sender_name
  # @option options [Hash] :properties properties
  # @option options [Hash] :keep_connection
  # @option options [Hash] :retry_interval
  # @option options [Hash] :retry_count
  # @return [Tengine::Event]
  def fire(event_or_event_type_name, options = {}, &block)
    @logger.debug("fire(#{event_or_event_type_name.inspect}, #{options}) called")
    opts = (options || {}).dup
    cfg = {
      :keep_connection => (opts.delete(:keep_connection) || default_keep_connection),
      :retry_interval  => opts.delete(:retry_interval),
      :retry_count     => opts.delete(:retry_count),
    }
    event =
      case event_or_event_type_name
      when Tengine::Event then event_or_event_type_name
      else
        Tengine::Event.new(opts.update(
          :event_type_name => event_or_event_type_name.to_s))
      end
    @mq_suite.fire self, event, cfg, block
    @logger.debug("fire(#{event_or_event_type_name.inspect}, #{options}) complete")
    event
  rescue Exception => e
    @logger.warn("fire(#{event_or_event_type_name.inspect}, #{options}) raised [#{e.class.name}] #{e.message}")
    raise e
  end

  def pending_events
    @mq_suite.pending_events_for self
  end

  # fireの中で勝手に待つようにしましたので、今後不要です。
  # 使っている箇所はやがて消していきましょう。
  def wait_for_connection
    yield
  end
end

# 
# Local Variables:
# mode: ruby
# coding: utf-8-unix
# indent-tabs-mode: nil
# tab-width: 4
# ruby-indent-level: 2
# fill-column: 135
# default-justification: full
# End:
