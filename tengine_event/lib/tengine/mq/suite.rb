# -*- coding: utf-8 -*-
require 'tengine/mq'

require 'active_support/version'
require 'active_support/core_ext/hash/deep_merge'
require 'tengine/support/core_ext/hash/compact'
require 'tengine/support/core_ext/hash/deep_dup'
require 'tengine/support/core_ext/hash/keys'
require 'tengine/support/core_ext/enumerable/each_next_tick'
require 'tengine/support/core_ext/enumerable/deep_freeze'
require 'tengine/support/core_ext/module/private_constant'
require 'tengine/support/method_traceable'
require 'amqp'
require 'amqp/extensions/rabbitmq'

class Tengine::Mq::Suite

  #######
  private
  #######

  PendingEvent = Struct.new :tag, :sender, :event, :opts, :retry, :block
  private_constant :PendingEvent

  # This is to accumulate a set of exceptions happend at a series of executions.
  class ExceptionsContainer < RuntimeError
    def initialize
      super
      @set = Array.new
    end

    # diagnostics
    def message
      msgs = @set.map {|i| i.message }.join "\n\t"
      sprintf "multiple exceptions are reported.\n\t%s", msgs
    end

    def << e
      @set << e
    end

    def raise
      case @set.size
      when 0
        # no exceptions
      when 1
        # only one exception happened inside
        Kernel.raise @set.first
      else
        # multiple.
        super
      end
    end
  end
  private_constant :ExceptionsContainer

  # Some (not all) of the descriptions below are quoted from the AMQP gem's yardoc.
  #
  # @param                [Hash]  cfg                   Tons  of  optional  arguments  can  be  specified and  they  are  settings  for
  #                                                     connections, queues, and senders.  But they are all optional, i.e. you are 100%
  #                                                     safe to omit the whole.  Specify only what you concern.
  # @option cfg           [Hash] :sender                Configurations for message sender, see below.
  # @option cfg           [Hash] :connection            Configurations for MQ connection, see below.
  # @option cfg           [Hash] :channel               Configurations for MQ channel, see below.
  # @option cfg           [Hash] :exchange              Configurations for MQ exchange, see below.
  # @option cfg           [Hash] :queue                 Configurations for MQ queue, see below.
  # @option sender     [Boolean] :keep_connection       Whether a  connection shall be shut  down after transmitted a  message, or not.
  #                                                     If  set,  a  sender  can  eventually  shut your  reactor  down  and  the  whole
  #                                                     EventMachine loop can be abandoned.
  # @option sender     [Numeric] :retry_interval        Seconds to wait before attempting  to retransmit a message after failure.  Zero
  #                                                     means an immediate retry so watch out.
  # @option sender     [Integer] :retry_count           Max count of retry  attempts.  Set zero here to stop sender  from even think of
  #                                                     retrying.
  # @option connection  [String] :user                  Authentication info.
  # @option connection  [String] :pass                  Authentication info.
  # @option connection  [String] :host                  Where to connect.
  # @option connection  [String] :port                  Where to connect.
  # @option connection  [String] :vhost                 The AMQP virtual host.
  # @option connection [Numeric] :timeout               Connection timeout in secs.
  # @option connection [Boolean] :logging               ?? Description TBD ??
  # @option connection [Boolean] :insist                ?? Description TBD ??
  # @option connection [Numeric] :auto_reconnect_delay  When set, a  TCP session loss yields an automatic  reconnect attempt, with this
  #                                                     delay (in secs).  Without it no reconnection attempts are made.
  # @option channel    [Numeric] :prefetch              Specifies number of messages to prefetch.  Learn more: AMQP's QoS features.
  # @option channel    [Boolean] :auto_recovery         Turns on automatic network failure recovery mode for the channel.  *Note* it is
  #                                                     highly  recommended  that you  leave  this  flag  untouched (default  enabled).
  #                                                     Otherwise you  have to have 100% control  over how to recover  your channel and
  #                                                     its dependent queues/exchanges.  That should be doable via #add_hook though.
  # @option exchange    [String] :name                  Explicit  name to  use,  or  empty (i.e.  "")  to let  the  broker allocate  an
  #                                                     appropriate name.
  # @option exchange    [Symbol] :type                  One of direct, fanout, topic, or headers.
  # @option exchange      [Hash] :publish               Default options for publishing messages.  See below.
  # @option exchange   [Boolean] :passive               If  set, the  server  will  not create  the  exchange if  it  does not  already
  #                                                     exist. The  client can  use this  to check whether  an exchange  exists without
  #                                                     modifying the server state.
  # @option exchange   [Boolean] :durable               If  set  when  creating  a  new  exchange,  the  exchange  will  be  marked  as
  #                                                     durable.  Durable exchanges  and their  bindings  are recreated  upon a  server
  #                                                     restart  (information  about   them  is  persisted).   Non-durable  (transient)
  #                                                     exchanges do not  survive if/when a server restarts  (information about them is
  #                                                     stored exclusively in RAM).
  # @option exchange   [Boolean] :auto_delete           If set,  the exchange is  deleted when all  queues have finished using  it. The
  #                                                     server waits  for a  short period  of time before  determining the  exchange is
  #                                                     unused to give time to the client code to bind a queue to it.
  # @option exchange   [Boolean] :internal              If set,  the exchange  may not be  used directly  by publishers, but  only when
  #                                                     bound to other exchanges. Internal  exchanges are used to construct wiring that
  #                                                     is not visible to applications. *This is a RabbitMQ-specific extension.*
  # @option exchange   [Boolean] :nowait                If set, the server will not respond  to the method.  The client should not wait
  #                                                     for a reply method.  If the server  could not complete the method it will raise
  #                                                     a channel or connection exception.
  # @option exchange   [Boolean] :no_declare            If set,  exchange declaration command  won't be sent  to the broker.  Allows to
  #                                                     forcefully  avoid declaration.  We recommend  that only  experienced developers
  #                                                     consider this option.
  # @option exchange    [String] :default_routing_key   Default routing key that will be used by AMQP::Exchange#publish when no routing
  #                                                     key is not passed explicitly.
  # @option exchange      [Hash] :arguments             A hash of optional arguments with the declaration.  Some brokers implement AMQP
  #                                                     extensions using x-prefixed declaration arguments.
  # @option publish     [String] :routing_key           Specifies message routing key.  Routing key determines what queues messages are
  #                                                     delivered to (exact routing algorithms vary between exchange types).
  # @option publish    [Boolean] :mandatory             This flag tells  the server how to react  if the message cannot be  routed to a
  #                                                     queue. If message is mandatory,  the server will return unroutable message back
  #                                                     to the client  with basic.return AMQP method.  If message is not mandatory, the
  #                                                     server silently drops the message.
  # @option publish    [Boolean] :immediate             This flag tells  the server how to react  if the message cannot be  routed to a
  #                                                     queue consumer  immediately.  If this  flag is set,  the server will  return an
  #                                                     undeliverable message with  a Return method.  If this flag  is zero, the server
  #                                                     will queue the message, but with no guarantee that it will ever be consumed.
  # @option publish    [Boolean] :persistent            When true, this message will be persisted to disk and remain in the queue until
  #                                                     it is consumed. When  false, the message is only kept in  a transient store and
  #                                                     will lost  in case of  server restart.  When  performance and latency  are more
  #                                                     important than  durability, set  :persistent => false.   If durability  is more
  #                                                     important, set :persistent => true.
  # @option publish     [String] :content_type          Content-type of message payload.
  # @option queue       [String] :name                  Explicit  name to  use,  or  empty (i.e.  "")  to let  the  broker allocate  an
  #                                                     appropriate name.
  # @option queue         [Hash] :subscribe             Default options for subscribing.  See below.
  # @option queue      [Boolean] :passive               If set, the server will not create  the queue if it does not already exist. The
  #                                                     client can  use this to  check whether the  queue exists without  modifying the
  #                                                     server state.
  # @option queue      [Boolean] :durable               If set when creating a new queue, the queue will be marked as durable.  Durable
  #                                                     queues  remain active when  a server  restarts.  Non-durable  queues (transient
  #                                                     queues) are purged if/when a server  restarts.  Note that durable queues do not
  #                                                     necessarily hold persistent  messages, although it does not  make sense to send
  #                                                     persistent messages to a transient queue (though it is allowed).
  # @option queue      [Boolean] :exclusive             Exclusive queues may only be  consumed from by the current connection.  Setting
  #                                                     the 'exclusive'  flag always implies  'auto-delete'. Only a single  consumer is
  #                                                     allowed  to  remove  messages  from   the  queue.   The  default  is  a  shared
  #                                                     queue. Multiple clients may consume messages from the queue.
  # @option queue      [Boolean] :auto_delete           If set, the  queue is deleted when all consumers have  finished using it.  Last
  #                                                     consumer  can  be  cancelled  either  explicitly  or  because  its  channel  is
  #                                                     closed. If there was no consumer ever on the queue, it won't be deleted.
  # @option queue      [Boolean] :nowait                If set, the server will not respond  to the method.  The client should not wait
  #                                                     for a reply method.  If the server  could not complete the method it will raise
  #                                                     a channel or connection exception.
  # @option queue         [Hash] :arguments             A hash of optional arguments with the declaration.  Some brokers implement AMQP
  #                                                     extensions  using  x-prefixed  declaration  arguments.  For  example,  RabbitMQ
  #                                                     recognizes x-message-ttl declaration arguments  that defines TTL of messages in
  #                                                     the queue.
  # @option subscribe  [Boolean] :ack                   If this  field is set to false  the server does not  expect acknowledgments for
  #                                                     messages.   That is,  when a  message  is delivered  to the  client the  server
  #                                                     automatically  and silently  acknowledges it  on  behalf of  the client.   This
  #                                                     functionality increases  performance but at the cost  of reliability.  Messages
  #                                                     can get lost if a client dies before it can deliver them to the application.
  # @option subscribe   [Boolean] :nowait               If set, the server  will not respond to the method. The  client should not wait
  #                                                     for a reply method.  If the server  could not complete the method it will raise
  #                                                     a channel or connection exception.
  # @option subscribe     [#call] :confirm              If set, this  proc will be called when the server  confirms subscription to the
  #                                                     queue with  a basic.consume-ok message. Setting this  option will automatically
  #                                                     set :nowait => false. This is required for the server to send a confirmation.
  # @option subscribe   [Boolean] :exclusive            Request exclusive  consumer access, meaning  only this consumer can  access the
  #                                                     queue.   This  is  useful  when  you  want a  long-lived  shared  queue  to  be
  #                                                     temporarily  accessible by  just one  application (or  thread, or  process). If
  #                                                     application exclusive consumer  is part of crashes or  loses network connection
  #                                                     to the broker, channel is closed and exclusive consumer is thus cancelled.
  def initialize cfg          =  Hash.new
    @terminating              =  false
    @mutex                    =  Mutex.new
    @condvar                  =  ConditionVariable.new
    @setting_up               =  Hash.new
    @state                    =  :uninitialized # see setup_handshake for possible values
    @firing_queue             =  EM::Queue.new
    @publishing_events        =  Array.new
    @retrying_events          =  Hash.new
    @pending_events           =  Hash.new
    @hooks                    =  Hash.new do |h, k| h.store k, Array.new end
    @config                   =  {
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
    @config.deep_merge! cfg.to_hash.deep_symbolize_keys.compact
    @config.deep_freeze
    install_default_hooks
  end

  ######
  public
  ######

  attr_reader :config

  # @yield        [args]       Given block is called when the hook condition met.
  # @yieldparam  [Array] args  Any arguments passed to the callback are passed through.
  # @param      [Symbol] name  Hook name to add
  def add_hook name, &block
    raise ArgumentError, "no block given" unless block_given?
    synchronize do
      @hooks[name.intern] << block
    end
  end

  # @yield      [header, payload]             Given block is called every time a message was received by the queue.
  # @yieldparam    [AMQP::Header]  header     Message metadata.
  # @yieldparam          [String]  payload    Message entity.
  # @param                 [Hash]  cfg        Subscription options
  # @option opts        [Boolean] :ack        Whether the broker (not us) expects acknowledgements from our side.  If this is true, you
  #                                           have  to call  header.ack somewhere  inside the  block, and  unacknowledged  messages are
  #                                           re-sent later.   Otherwise you need not to  call header.ack, and the  server doesn't know
  #                                           your sudden death or packet loss or network problems.
  # @option opts        [Boolean] :nowait     With this flag  on, like other :nowait  cases, the request is dealt  silently.  Don't get
  #                                           confused: the broker do  not respond to the subscribe request, but  does push messages to
  #                                           us. i.e. this flag only affects to :confirm optional argument.
  # @option opts          [#call] :confirm    This is called when the broker replied  your subscription.  I have never seen this called
  #                                           twice.  This argument assumes :nowait => false.
  # @option opts        [Boolean] :exclusive  Request exclusive consumer access, meaning only this consumer can access the queue.  When
  #                                           you experience a  network problem, exclusive access is cancelled.  Which  itself is not a
  #                                           strange behaviour, but if you do  a auto-recover the exclusivity might suddenly lost.  So
  #                                           beware.
  def subscribe cfg = Hash.new
    raise ArgumentError, "no block given" unless block_given?
    ensures :queue do |q|
      opts = @config[:queue][:subscribe].merge cfg.compact
      q.subscribe opts do |h, b|
        yield h, b
      end
    end
  end

  # @yield                                  [cok]          Given  block is  called  after  it had  successfully  ubsubscribed from  the
  #                                                        broker.
  # @yieldparam [AMQP::Protocol::Basic::CancelOK]  cok     Message metadata.  *Note* can be nil when you set nowait: true.
  # @param                                 [Hash]  cfg     Subscription options
  # @option opts                        [Boolean] :nowait  With this flag on, like other  :nowait cases, the request is dealt silently.
  #                                                        The block is called anyway though.
  def unsubscribe cfg = Hash.new
    raise ArgumentError, "no block given" unless block_given?
    synchronize do
      if ivar? :queue and @queue.default_consumer
        cfg[:nowait] = cfg.fetch :nowait, false
        if cfg[:nowait]
          @queue.unsubscribe cfg
          yield nil
        else
          @queue.unsubscribe cfg do |cok|
            yield cok
          end
        end
      else
        logger :warn, "unsubscribe called but not subscribed"
        yield nil
      end
    end
  end

  # You don't have to understand it.  Use Tengine::Event::Sender.
  #
  # @param [Tengine::Event::Sender]  sender           Event sender
  # @param         [Tengine::Event]  event            Event to submit
  # @param                   [Hash]  opts             Options to pass to the publisher
  # @param                  [#call]  block            Callback to be triggered *after* the transmission.
  # @option opts          [Boolean] :keep_connection  Whether a connection shall be shut  down after transmitted a message, or not.  If
  #                                                   set, a  sender can eventually shut  your reactor down and  the whole EventMachine
  #                                                   loop can be abondoned.
  # @option opts          [Numeric] :retry_interval   Seconds to wait before attempting to retransmit a message after failure.
  # @option opts          [Numeric] :retry_count      Max count of retry attempts.
  def fire sender, event, opts, block
    cfg = @config[:sender].merge opts.compact
    e = PendingEvent.new 0, sender, event, cfg, 0, block
    synchronize do
      @pending_events[e] = true
      case @state when :disconnected
        # wait for next connection
        @retrying_events[e] = [nil, Time.at(0)]
      else
        @firing_queue.push e # serialize
        trigger_firing_thread if @firing_queue.size <= 1 # first kick
      end
    end
  end

  # stops the suite.
  def stop
    # べつに何も難しいことがしたいわけではなくて最終的にp0を呼べばいいんだけど、EMがいるかいないか、@connectionがいるかいないかの条件分
    # けで無駄に長いメソッドになっている。

    p0 = lambda do
      EM.cancel_timer @reconnection_timer if ivar? :reconnection_timer
      @retrying_events.each_value do |(idx, *)|
        EM.cancel_timer idx if idx
      end
      @retrying_events.clear
      stop_firing_queue

      @state = :uninitialized # この後またEM.run{ .. }されるかも
      @setting_up.clear
      @firing_queue = EM::Queue.new
      @connection = nil
      @channel = nil
      @queue = nil
      @exchange = nil
      @reconnection_timer = nil
      GC.start # 気休め

      logger :info, "OK, stopped.  Good bye."
      if block_given? then
        yield
      else
        EM.stop
      end
    end

    p1 = lambda do
      if ivar? :connection
        @connection.disconnect do
          synchronize do
            p0.call
          end
        end
      else
        p0.call
      end
    end

    p2 = lambda do
      if ivar? :channel
        @channel.close do
          synchronize do
            p1.call
          end
        end
      else
        p1.call
      end
    end

    p3 = lambda do
      if ivar? :queue and @queue.default_consumer
        @queue.unsubscribe :nowait => false do
          synchronize do
            p2.call
          end
        end
      else
        p2.call
      end
    end

    p4 = lambda do
      logger :debug, "NEW THREAD " << ('>' * 50)
      logger :debug, "#{self.class}##stop p4"
      synchronize do
        logger :info, "finishing up, now sending remaining events."
        until @pending_events.empty?
          logger :debug, "@condvar.wait @mutex until @pending_events.empty?" << ('?' * 50)
          @condvar.wait @mutex
          logger :debug, "@condvar.wait @mutex done                        " << ('!' * 50)
        end
      end
      logger :debug, "#{self.class}##stop p4"
      logger :debug, "THREAD END" << ('<' * 50)
    end

    p5 = lambda do |a|
      synchronize do
        p3.call
      end
    end

    initiate_termination do
      if EM.reactor_running?
        EM.defer p4, p5
      elsif block_given?
        yield
      end
    end
  end

  # Declares that the  application is now terminating  this MQ connection.  No reconnection  / resend attempts are made  any more.  The
  # connection (if any) is  still open and you can push / pull  using it, but by calling this method you  hereby agree that no messages
  # involving this suite are reliable any longer.
  #
  # Yields after the declaration.
  def initiate_termination
    @terminating = true # FIXME: should be mutex-protected
    yield
  end

  def inspect
    sprintf "#<%p:%#x %s cfg=%p ev=%p hook=%p>", self.class, self.object_id, @state, @config, @pending_events, @hooks
  end

  def pretty_print pp
    pp.pp_object self
  end

  # used by pretty printer
  def pretty_print_instance_variables
    %w[@state @config @pending_events @hooks]
  end

  #######

  # @deprecated Do not use it.
  def connection; deprecated :connection end

  # @deprecated Do not use it.
  def channel; deprecated :channel end

  # @deprecated Do not use it.
  def exchange; deprecated :exchange end

  # @deprecated Do not use it.
  def queue; deprecated :queue end

  #######

  # @api private
  def pending_events
    synchronize do
      @pending_events.keys.select {|i| yield i }.map {|i| i.event }
    end
  end

  # @api private
  def pending_events_for sender
    pending_events do |i|
      i.sender == sender
    end
  end

  # @api private
  def self.pending? event
    e = ObjectSpace.each_object self
    e.any? do |obj|
      not obj.pending_events do |i| i.event == event end.empty?
    end
  end

  #######
  private
  #######

  # A thin Tengine.logger wrapper.  As this gem can be used without a logger, we have to work around it.
  # @param [Symbol] lv   One of debug, info, warn, error, fatal, or Logger constants.
  # @param [String] fmt  printf format
  # @param  [Array] argv printf variadic arguments
  def logger lv, fmt, *argv
    msg = sprintf fmt, *argv
    if defined? Tengine.logger
      Tengine.logger.send lv, msg
    else
      STDERR.puts msg
    end
  end

  # Wanted to avoid recursive mutex  deadlocking, so this convenient method.  But beware, recursive locking  situation is in fact a bad
  # habit (if not a bug), and we pay a considerable cost to avoid them here.  This method is far from being lightweight especially when
  # recursive locking happens.
  def synchronize
    begin
      logger :debug, "GETTING LOCK mutex" << ('?' * 50)
      @mutex.lock
      logger :info , "GET     LOCK mutex" << ('!' * 50)
    rescue ThreadError => e
      # A deadlock was detected, which means of course, we have the lock.
      bt = e.backtrace.join "\n\tfrom "
      logger :debug, "%s\n\tfrom %s", e, bt
    ensure
      begin
        return yield
      ensure
        begin
          @mutex.unlock
          logger :debug, "RELEASE LOCK mutex" << ('-' * 50)
        rescue ThreadError => e
          # @mutex might  magically be unlocked...   For instance, the execution  context might have  been splitted from inside  of the
          # yielded block.  That case, the context who reached here do not own @mutex so should not unlock.
          bt = e.backtrace.join "\n\tfrom "
          logger :warn, "%s\n¥tfrom %s\n", e, bt
        end
      end
    end
  end

  # suppress warning on debug mode
  def ivar? name
    vid = "@#{name}"
    instance_variable_defined?(vid) && instance_variable_get(vid)
  end

  # misc also
  def rehash_them_all
    instance_variables.each do |i|
      obj = instance_variable_get i
      case obj when Hash then
        obj.rehash unless obj.frozen?
      end
    end
  end

  #######

  # Generates a callback according to klass and mid
  # @param [String] klass callback category
  # @param [Symbol] mid   callback ID
  # @return [Proc] a callback.
  def callback_entity klass, mid
    lambda do |*argv|
      exceptions = ExceptionsContainer.new
      begin
        @hooks[:everything].reverse_each do |proc|
          begin
            proc.yield klass, mid, argv
          rescue Exception => e
            exceptions << e
          end
        end

        @hooks[:"#{klass}.#{mid}"].reverse_each do |proc|;
          begin
            proc.yield(*argv)
          rescue Exception => e
            exceptions << e
          end
        end
      ensure
        exceptions.raise
      end
    end
  end

  def deprecated klass
    # このメソッドは警告を表示する。デバッグ用。
    synchronize do
      obj = ivar? klass
      if obj
        logger :debug, "Deprecation warning.  Method %s called from %s", klass, caller[3]
      else
        raise RuntimeError, "found a timing issue. please report to @shyouhei with a reproducible sample code."
      end
      return obj
    end
  end

  # @yields [obj] yields generated object
  def ensures klass
    raise "eventmachine's reactor needed" unless EM.reactor_running?
    logger :debug, "#ensures(#{klass.inspect})"
    # このメソッドはEM.deferでklassの初期化を待つ。EM.deferだから戻り値を使ってはいけない。引数のブロックは、klassが初期化されたことが確
    # 認された後にcallされる。
    p1 = lambda do
      logger :debug, "NEW THREAD " << ('>' * 50)
      logger :debug, "#{self.class}##ensures(#{klass.inspect}) p1"
      synchronize do
        unless ivar? klass
          setups klass unless @setting_up[klass]
          until ivar? klass
            logger :debug, "@condvar.wait @mutex until ivar? klass " << ('?' * 50)
            @condvar.wait @mutex
            logger :debug, "@condvar.wait @mutex done              " << ('!' * 50)
          end
        end
      end
      logger :debug, "#{self.class}##ensures(#{klass.inspect}) p1"
      logger :debug, "THREAD END" << ('<' * 50)
    end
    p2 = lambda do |a|
      obj = ivar? klass
      yield obj if block_given?
    end
    EM.defer p1, p2
  end

  def generate_connection cb
    cfg = cb.merge @config[:connection] do |k, v1, v2| v2 end
    AMQP.connect cfg do |conn|
      synchronize do
        @state = :connected
      end
      yield conn
    end
  rescue AMQP::TCPConnectionFailed
    # on_tcp_connection_failrueは指定しているのだけれどそれでもこの例外はあがってくるのだろうか? よくわからない
    # いちおう同じことをさせておく
    cfg[:on_tcp_connection_failrue].yield cfg
  end

  def generate_channel *;
    cfg = @config[:channel]
    ensures :connection do |conn|
      id = AMQP::Channel.next_channel_id
      AMQP::Channel.new conn, id, cfg do |ch|
        yield ch
      end
    end
  end

  def generate_queue *;
    cfg = @config[:queue].dup
    name = cfg.delete :name
    ensures :exchange do |xchg|
      if cfg[:nowait]
        que = @channel.queue name, cfg
        que.bind xchg
        yield que
      else
        @channel.queue name, cfg do |que|
          que.bind xchg, :nowait => false do
            yield que
          end
        end
      end
    end
  end

  def generate_exchange *;
    cfg = @config[:exchange].dup
    name = cfg.delete :name
    type = cfg.delete :type
    cfg.delete :publish # not needed here
    ensures :channel do |ch|
      if cfg[:nowait]
        xchg = AMQP::Exchange.new ch, type.intern, name, cfg
        yield xchg
      else
        AMQP::Exchange.new ch, type.intern, name, cfg do |xchg|
          yield xchg
        end
      end
    end
  end

  def hooks_basic
    %w[
      before_recovery
      after_recovery
      on_connection_interruption
    ]
  end
  alias hooks_queue hooks_basic
  alias hooks_exchange hooks_queue

  def hooks_channel
    hooks_basic + %w[on_error]
  end

  def hooks_connection
    hooks_channel + %w[
      on_closed
      on_possible_authentication_failure
      on_tcp_connection_failure
      on_tcp_connection_loss
    ]
  end

  @@is_under_rspec = \
    begin
      RSpec
    rescue NameError
      false
    end

  def setups klass
    # このメソッドはvidの初期化を実際に行う。mutexは確保されている前提である。
    @setting_up[klass] = true
    mids = send "hooks_#{klass}"
    callbacks = mids.inject Hash.new do |r, x|
      y = x.intern
      cb = callback_entity klass, y
      r.update y => cb
    end

    send "generate_#{klass}", callbacks do |obj|
      callbacks.each_pair do |k, v|
        if @@is_under_rspec
          begin
            obj.send k, &v
          rescue RSpec::Mocks::MockExpectationError
            # objはmock objectかも...
          end
        else
          obj.send k, &v
        end
      end

      unless @@is_under_rspec
        # rspec ではないとき(テスト以外)はundefしておく
        # 本当はテスト時もundefしたいが...
        eigen = class << obj; self; end
        eigen.send :undef_method, *mids
      end

      synchronize do
        instance_variable_set "@#{klass}", obj
        logger :debug, "before @condvar.broadcast" << ('-' * 50)
        @condvar.broadcast
        logger :debug, " after @condvar.broadcast"
      end
    end
  end

  #######

  def ensures_handshake
    raise ArgumentError, "no block given" unless block_given?
    raise "eventmachine's reactor needed" unless EM.reactor_running?
    logger :debug, "ensures_handshake @state: #{@state.inspect}"
    case @state when :established, :unsupported
      EM.next_tick do yield end
    else
      # 2段階のEM.deferを行っている。まず初段で@channelの初期化をキックして、channel -> connectionと依存関係をたぐってコネクションを確立
      # する。channelを成立させるところまでの待ち合わせが第一段。次に、生成した@channelを用いてpublisher confirmationのハンドシェイクを
      # キックして、これが確立するのを待つのが第二段。
      logger :info, "waiting for MQ to be set up (now %s)...", @state

      d4 = lambda do |a|
        logger :debug, "#ensures_handshake :d3 #{__LINE__}"
        res = yield
        logger :debug, "#ensures_handshake :d3 #{__LINE__}"
        res
      end
      d3 = lambda do
        logger :debug, "NEW THREAD " << ('>' * 50)
        logger :debug, "#{self.class}##ensures_handshake :d3 #{__LINE__}"
        synchronize do
          logger :debug, "#ensures_handshake :d3 #{__LINE__}"
          unless ensures_handshake_internal
            logger :debug, "#ensures_handshake :d3 #{__LINE__}"
            setups_handshake unless @setting_up[:handshake]
            logger :debug, "#ensures_handshake :d3 #{__LINE__}"
            # @condvar.wait @mutex until ensures_handshake_internal
            @mutex.sleep 0.1 until ensures_handshake_internal
            logger :debug, "#ensures_handshake :d3 #{__LINE__}"
          end
          logger :debug, "#ensures_handshake :d3 #{__LINE__}"
        end
        logger :debug, "#{self.class}##ensures_handshake :d3 #{__LINE__}"
        logger :debug, "THREAD END" << ('<' * 50)
      end
      d2 = lambda do |a|
        logger :debug, "#ensures_handshake :d2 #{__LINE__}"
        EM.defer d3, d4
        logger :debug, "#ensures_handshake :d2 #{__LINE__}"
      end
      d1 = lambda do
        logger :debug, "NEW THREAD " << ('>' * 50)
        logger :debug, "#{self.class}##ensures_handshake :d1 #{__LINE__}"
        synchronize do
          logger :debug, "#ensures_handshake :d1 #{__LINE__}"
          ensures :channel
          logger :debug, "#ensures_handshake :d1 #{__LINE__}"
          until ivar? :channel
            logger :debug, "@condvar.wait @mutex until ivar? :channel" << ('?' * 50)
            @condvar.wait @mutex
            logger :debug, "@condvar.wait @mutex done                " << ('!' * 50)
          end
          logger :debug, "#ensures_handshake :d1 #{__LINE__}"
        end
        logger :debug, "#{self.class}##ensures_handshake :d1 #{__LINE__}"
        logger :debug, "THREAD END" << ('<' * 50)
      end
      d0 = lambda do
        logger :debug, "#ensures_handshake :d0 #{__LINE__}"
        res = EM.defer d1, d2
        logger :debug, "#ensures_handshake :d0 #{__LINE__}"
        res
      end
      d0.call
    end
  end

  def ensures_handshake_internal
    case @state when :established, :unsupported
      true
    else
      false
    end
  end

  def setups_handshake
    @setting_up[:handshake] = true
    # possible values of @state:
    #
    # :uninitialized --- not connected yet
    # :disconnected  --- connection lost and still not recovered
    # :connected     --- AMQP session established (no handshake yet)
    # :handshaking   --- handshake in progress, not established yet
    # :established   --- proper handshake was made
    # :unsupported   --- peer rejected handshake, but the connection itself is OK.
    cap = @connection.server_capabilities
    if cap and cap["publisher_confirms"] then
      @state = :handshaking
      @channel.confirm_select do
        # this is in next EM loop...
        synchronize do
          reinvoke_retry_timers unless @retrying_events.empty?
          @channel.on_ack do |ack|
            # this is in another EM loop...
            consume_basic_ack ack 
          end
          @channel.on_nack do |ack|
            # this is in yet another EM loop...
            consume_basic_nack ack 
          end
          @tag = 0
          @state = :established
          @setting_up.delete :handshake
          logger :debug, "before @condvar.broadcast" << ('-' * 50)
          @condvar.broadcast
          logger :debug, " after @condvar.broadcast"
        end
      end
    else
      logger :warn, <<-end

The  message  queue  broker   you  are  connecting   lacks  Publisher [BEWARE!]
Confirmation capability,  so we cannot make  sure your events  are in [BEWARE!]
fact reaching  to one  of the Tengine  cores.  We strongly  recommend [BEWARE!]
you to use a relatively recent version of RabbitMQ.                   [BEWARE!]

      end
      @state = :unsupported
      @setting_up.delete :handshake
      logger :debug, "before @condvar.broadcast" << ('-' * 50)
      @condvar.broadcast
      logger :debug, " after @condvar.broadcast"
    end
  end

  def consume_basic_ack ack
    synchronize do
      f = @publishing_events.empty?
      n = ack.delivery_tag
      ok = []
      ng = []
      if ack.multiple
        ok, @publishing_events = @publishing_events.partition {|i| i.tag <= n }
      else
        ng, @publishing_events = @publishing_events.partition {|i| i.tag < n }
        if @publishing_events.empty?
          # the packet in quesion is lost?
        elsif ev = @publishing_events.shift
          ok = [ev]
        end
      end
      f ||= !ng.empty?
      ng.each_next_tick do |e|
        synchronize do
          # NGなので再送
          e.retry += 1
          rehash_them_all
          @firing_queue.push e
        end
      end
      ok.each_next_tick do |e|
        # OK, ブロックを評価
        e.block.call if e.block
      end
      unless ok.empty?
        rehash_them_all
        ok.each do |e|
          # ただしく停止させるために上のnext_tickではなくここで
          @retrying_events.delete e
          @pending_events.delete e
        end
        logger :debug, "before @condvar.broadcast" << ('-' * 50)
        @condvar.broadcast
        logger :debug, " after @condvar.broadcast"
        f = ok.inject f do |r, e| r | e.opts[:keep_connection] end
      end
      # 帰ってきたackが最後のackで、もう待ちがなくて、かつackに対応するイベントがすべてkeep_connection: falseで送信されていた場合、もう
      # このリアクターは止めていいい。ngが空でなければ@pending_eventsには何か入っている。
      stop if f == false and @pending_events.empty?
    end
  end

  def consume_basic_nack nack
    # nackされたら(再送するから)止まっちゃだめ。なので逆にフローはシンプル。
    synchronize do
      n = nack.delivery_tag
      ng = []
      if ack.multiple
        ng, @publishing_events = @publishing_events.partition {|i| i.tag <= n }
      else
        ng, @publishing_events = @publishing_events.partition {|i| i.tag < n }
        if @publishing_events.empty?
          # the packet in quesion is lost?
        elsif ev = @publishing_events.shift
          ng = [ev]
        end
      end
      ng.each_next_tick do |e|
        synchronize do
          e.retry += 1
          rehash_them_all
          @firing_queue.push e
        end
      end
    end
  end

  #######

  def revoke_retry_timers
    synchronize do
      if @state != :disconnected
        @state = :disconnected
        @retrying_events.each_value do |(idx, *)|
          EM.cancel_timer idx if idx
        end
        # all unacknowledged events are hereby considered LOST
        t0 = Time.at 0
        @publishing_events.each do |e|
          @retrying_events[e] = [nil, t0]
        end
      end
    end
  end

  def reinvoke_retry_timers
    synchronize do
      @retrying_events.each_pair.to_a.each_next_tick do |i, (j, k)|
        u = (k + (i.opts[:retry_interval] || 0)) - Time.now
        if u < 0
          # retry interval passed, just send it again
          @firing_queue.push i
        else
          # need to re-add timer (no repeat)
          EM.add_timer u do @firing_queue.push i end
        end
      end
      @retrying_events.clear
      trigger_firing_thread
    end
  end

  def install_default_hooks
    add_hook :everything do |klass, mid, *argv|
      logger :debug, "AMQP event callback: %s.%s", klass, mid#, argv
    end

    add_hook :'connection.before_recovery' do |conn|
      EM.cancel_timer @reconnection_timer if ivar? :reconnection_timer
    end

    add_hook :'connection.on_tcp_connection_loss' do |conn|
      # Wow! AMQP::Session#reconnect is brain-damaged that it cannot be cancelled!
      # conn.reconnect false, auto_reconnect_delay.to_i if auto_reconnect_delay and not @terminating

      ard  = @config[:connection][:auto_reconnect_delay]
      host = @config[:connection][:host]
      port = @config[:connection][:port]
      if ard and not @terminating and conn.closed?
        conn.instance_eval { @reconnecting = true; reset }
        @reconnection_timer = EM.add_timer ard do
          EM.reconnect host, port, conn
          @reconnection_timer = nil
        end
      end
    end

    add_hook :'connection.on_tcp_connection_failure' do |setting|
      @mutex.synchronize do
        case @state when :uninitialized then
          # 最初の接続に失敗した場合。https://www.pivotaltracker.com/story/show/18317933
          raise "It seems the MQ broker is missing (misconfiguration?)"
        else
          logger :error, "It seems the MQ broker is missing."
        end
      end
    end

    add_hook :'channel.on_connection_interruption' do |ch|
      revoke_retry_timers
    end

    add_hook :'channel.after_recovery' do |ch|
      # AMAZING that an AMQP::Channel instance deletes a once-registered callbacks!
      # see: amq/client/async/channel.rb, search for "def reset_state!"
      a = AMQ::Client::Async::Channel
      hooks_channel.inject(Hash.new) {|r, x|
        r.update x.intern => callback_entity(:channel, x.intern)
      }.each_pair {|k, v|
        a.instance_method(k).bind(ch).call(&v)
      }

      ch.prefetch @config[:channel][:prefetch] do
        @setting_up.delete :handshake # re-initialize
        reinvoke_retry_timers
        logger :debug, "before @condvar.broadcast" << ('-' * 50)
        @condvar.broadcast
        logger :debug, " after @condvar.broadcast"
      end
    end

    add_hook :'connection.after_recovery' do |conn|
      synchronize do
        @state = :connected
      end
    end
  end

  #######

  def stop_firing_queue
    # beautiful...
    @firing_queue.instance_eval do
      @items.clear
      @popq.clear
    end
  end

  def gencb
    @gencb ||= lambda do |ev|
      case @state when :unsupported, :established
        fire_internal ev
        @firing_queue.pop(&gencb)
      else
        # disconnectedとか。
        # 無視?
        @firing_queue.push ev
      end
    end
    @gencb
  end

  def trigger_firing_thread
    # inside mutex
    # event already pushed
    ensures_handshake do
      ensures :exchange do
        synchronize do
          @firing_queue.pop(&gencb)
        end
      end
    end
  end

  def fire_internal ev
    publish ev
  rescue Exception => ex
    logger :warn, "#{self.class.name}#fire_internal [#{ex.class}] #{ex.message}"
    # exchange.publish はたとえば RuntimeError を raise したりするようだ
    publish_failed ev, ex
  else
    published ev
  end

  def publish ev
    @exchange.publish ev.event.to_json, @config[:exchange][:publish]
  end

  def publish_failed ev, ex
    if resendable_p ev
      idx = EM.add_timer ev.opts[:retry_interval] do
        synchronize do
          ev.retry += 1
          @firing_queue.push ev
        end
      end
      @retrying_events[ev] = [idx, Time.now]
    else
      # inside mutex lock
      rehash_them_all
      @retrying_events.delete ev
      @pending_events.delete ev
      @publishing_events.reject! {|i| i == ev }
      logger :debug, "before @condvar.broadcast" << ('-' * 50)
      @condvar.broadcast
      logger :debug, " after @condvar.broadcast"
      logger :fatal, "SEND FAILED: EVENT LOST %p", ev.event
      stop unless ev.opts[:keep_connection] # 送信失敗かつコネクション維持しないということはここで停止すべき
    end
  end

  def resendable_p ev
    return false if @terminating and not @connection
    return false if @terminating and not @connection.connected?
    return ev.retry < ev.opts[:retry_count]
  end

  def published ev
    case @state
    when :unsupported then
      # ackなし、next_tickをもって送信終了と見なす
      EM.next_tick do
        synchronize do
          rehash_them_all
          @retrying_events.delete ev
          @pending_events.delete ev
          @publishing_events.reject! {|i| i == ev }
          logger :debug, "before @condvar.broadcast" << ('-' * 50)
          @condvar.broadcast
          logger :debug, " after @condvar.broadcast"
          ev.block.call if ev.block
          stop unless ev.opts[:keep_connection]
        end
      end
    when :established then
      # ackあり、ackを待つ
      @tag += 1
      ev.tag = @tag
      rehash_them_all
      @publishing_events.push ev
    end
  end

  extend Tengine::Support::MethodTraceable
  methods = self.instance_methods + self.private_instance_methods -
         Object.instance_methods - Object.private_instance_methods -
    [:logger, ]
  methods.delete_if{|m| m.to_s =~ /\?$/}
  method_trace(methods)
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
