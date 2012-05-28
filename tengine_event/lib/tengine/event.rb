# -*- coding: utf-8 -*-
require 'tengine_event'

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/keys'
require 'active_support/json'
require 'uuid'

ActiveSupport::OrderedHash = Hash unless defined?(ActiveSupport::OrderedHash)

# Serializable Class of object to send to an MQ or to receive from MQ.
class Tengine::Event

  autoload :Sender, 'tengine/event/sender'
  autoload :ModelNotifiable, 'tengine/event/model_notifiable'

  class << self
    # see Tengine::Event::Sender#fire
    def fire(*args, &block)
      default_sender.fire(*args, &block)
    end

    def config; @config ||= {}; end
    def config=(v); @config = v; end

    attr_writer :mq_suite
    def mq_suite; @mq_suite ||= Tengine::Mq::Suite.new(config); end

    attr_writer :default_sender
    def default_sender
      @default_sender ||= Tengine::Event::Sender.new(mq_suite)
    end

    def uuid_gen
      # uuidtools と uuid のどちらが良いかは以下のサイトを参照して uuid を使うようにしました。
      # http://d.hatena.ne.jp/kiwamu/20090205/1233826235
      @uuid_gen ||= ::UUID.new
    end

    # jsonの文字列からTengine::Eventのオブジェクトを解釈して生成します
    def parse(str)
      case raw_parsed = JSON.parse(str)
      when Hash then
        new(raw_parsed)
      when Array then
        raw_parsed.map{|hash| new(hash)}
      else
      end
    end

    # @attribute
    # host_nameが実行するコマンド。デフォルトでは hostname。
    def host_name_command; @host_name_command ||= "hostname"; end
    attr_writer :host_name_command

    # ホスト名を取得する
    # 内部ではhost_name_commandで指定されたコマンドを実行しています。
    # @return [String]
    def host_name
      `#{host_name_command}`.strip
    end

    # source_nameが指定されていない場合に設定される文字列を返します
    # config[:default_source_name] に値が設定されていなかったらhost_nameの値が使用されます
    def default_source_name; config[:default_source_name] || "#{host_name}/#{Process.pid}"; end

    # sender_nameが指定されていない場合に設定される文字列を返します
    # config[:default_sender_name] に値が設定されていなかったらhost_nameの値が使用されます
    def default_sender_name; config[:default_sender_name] || "#{host_name}/#{Process.pid}"; end

    # levelが指定されていない場合に設定される文字列を返します
    # config[:default_level] に値が設定されていなかったらhost_nameの値が使用されます
    def default_level
      LEVELS_INV[(config[:default_level_key] || :info).to_sym]
    end
  end

  # constructor
  # @param [Hash] attrs the options for attributes
  # @option attrs [String] :key attriute key
  # @option attrs [String] :event_type_name event_type_name
  # @option attrs [String] :source_name source_name
  # @option attrs [Time] :occurred_at occurred_at
  # @option attrs [Integer] :level level
  # @option attrs [Symbol] :level_key level_key
  # @option attrs [String] :sender_name sender_name
  # @option attrs [Hash] :properties properties
  # @return [Tengine::Event]
  def initialize(attrs = nil)
    if attrs
      raise ArgumentError, "attrs must be a Hash but was #{attrs.inspect}" unless attrs.is_a?(Hash)
      attrs.each do |key, value|
        send("#{key}=", value)
      end
    end
    klass = self.class
    @key ||= klass.uuid_gen.generate # Stringを返す
    @source_name ||= klass.default_source_name
    @sender_name ||= klass.default_sender_name
    @level ||= klass.default_level
    @occurred_at ||= Time.now.utc
  end

  # @attribute
  # キー。インスタンス生成時に同じ意味のイベントには同じキーが割り振られます。
  attr_accessor :key

  # @attribute
  # イベント種別名。
  attr_reader :event_type_name
  def event_type_name=(v); @event_type_name = v.nil? ? nil : v.to_s; end

  # @attribute
  # イベントの発生源名。
  attr_reader :source_name
  def source_name=(v); @source_name = v.nil? ? nil : v.to_s; end

  # @attribute
  # イベントの発生日時。
  attr_accessor :occurred_at
  def occurred_at=(v)
    case v
    when nil then @occurred_at = nil
    when Time then @occurred_at = v.utc
    when String then
      @occurred_at = v.respond_to?(:to_time) ? v.to_time : Time.respond_to?(:parse) ? Time.parse(v) : v
    else
      raise ArgumentError, "occurred_at must be a Time but was #{v.inspect}" unless v.is_a?(Time)
    end
  end

  # from level to level_key
  LEVELS = {
      0 => :gr_heartbeat,
      1 => :debug,
      2 => :info,
      3 => :warn,
      4 => :error,
      5 => :fatal,
  }.freeze

  # from level_key to level
  LEVELS_INV = LEVELS.invert.freeze

  # @attribute
  # イベントの通知レベル
  attr_accessor :level
  def level=(val)
    if val && !LEVELS.keys.include?(val)
      raise ArgumentError, "Invalid level #{val.inspect}. It must be one of #{LEVELS.keys.inspect}"
    end
    @level = val
  end

  # @attribute
  # イベントの通知レベルキー
  # :gr_heartbeat/:debug/:info/:warn/:error/:fatal
  def level_key; LEVELS[level];end
  def level_key=(v)
    if v
      unless val = LEVELS_INV[v.to_sym]
        raise ArgumentError, "Invalid level_key #{v.inspect}. It must be one of #{LEVELS_INV.keys.inspect}"
      end
      self.level = val
    else
      self.level = nil
    end
  end

  # @attribute
  # イベントの送信者名。
  attr_reader :sender_name
  def sender_name=(v); @sender_name = v.nil? ? nil : v.to_s; end


  # @attribute
  # プロパティ。他の属性だけでは表現できない諸属性を格納するHashです。
  def properties
    @properties ||= {}
  end

  def properties=(hash)
    @properties = (hash || {}).stringify_keys
  end

  ATTRIBUTE_NAMES = [:event_type_name, :key, :source_name, :occurred_at, :level, :sender_name, :properties].freeze

  # @return [Hash] attributes of this object
  def attributes
    ATTRIBUTE_NAMES.inject({}) do |d, attr_name|
      v = send(attr_name)
      d[attr_name] = v unless v.blank?
      d
    end
  end

  def transmitted?
    not Tengine::Mq::Suite.pending?(self)
  end

end
