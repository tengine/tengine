# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

class Tengine::Job::Runtime::Signal

  class Error < StandardError
  end

  attr_reader :paths, :reservations, :event

  # @attribute 受け渡しのためにデータを一時的に保持する属性。
  # 現時点ではジョブのrunからackを返す際にPIDを保持するために使用します。
  attr_accessor :data

  # start.job.job.tengineイベントによって
  # ジョブは :ready -> :starting -> :running に遷移するが、
  # 一度のroot_jobnet.update_with_lock では :starting が保存されないので、
  # 2回のroot_jobnet.update_with_lock に分けることができるようにするための
  # 処理を記憶しておく属性です
  attr_reader :callback
  attr_reader :callbacks

  def initialize(event)
    @event = event
    reset
  end

  def reset
    @cache = {}
    @paths = []
    @reservations = []
    @data = nil
    @callback = nil
    @callbacks = []
  end

  def callback=(value)
    Tengine.logger.warn("Tengine::Job::Runtime::Signal#callback= is deprecated. Use call_later instead of it.\n  " << caller.join("\n  "))
    @callback = value
  end

  def call_later(&block)
    @callbacks.push(block)
  end

  def process_callbacks
    until self.callbacks.empty?
Tengine.logger.debug("-" * 20)
      callbacks.shift.call
    end

    while self.callback
      block, @callback = @callback, nil
      block.call
    end
  end

  def remember(obj)
    if obj.is_a?(Array)
      obj.each{|o| remember(o)}
    else
      return nil if obj.nil?
      key = cache_key(obj)
      cached = cache(*key)
      return cached if cached
      @cache[key] = obj
    end
    obj
  end

  def cache(*args)
    case args.length
    when 1 then
      obj = args.first
      return nil if obj.nil?
      if obj.is_a?(Array)
        obj.map{|o| cache(o)}
      else
        cache(*cache_key(obj)) || remember(obj)
      end
    when 2 then
      @cache[args]
    else
      raise ArgumentError, "#{self.class.name}#cache requires 1 or 2 arguments"
    end
  end

  def remember_all(vertex)
    v = Tengine::Job::Structure::Visitor::AllWithEdge.new{|obj| remember(obj) }
    vertex.accept_visitor(v)
  end

  def cache_key(obj)
    return [obj.class.name, obj.id.to_s]
  end

  def cache_list
    Tengine.logger.debug "-" * 100
    Tengine.logger.debug "#{__FILE__}##{__LINE__}"
    Tengine.logger.debug "object_id: #{object_id}"
    @cache.each do |key, obj|
      Tengine.logger.debug "#{obj.object_id} #{key.inspect} #{obj.inspect}" << (obj.changed? ? " CHANGED" : "")
    end
    Tengine.logger.debug "-" * 100
  end

  def changed_vertecs
    @cache.values.select(&:changed?).
      map{|obj| obj.is_a?(Tengine::Job::Runtime::Edge) ? obj.owner : obj}.
      uniq
  end

  def execution
    @execution ||= Tengine::Job::Runtime::Execution.find(event[:execution_id])
  end

  def leave(obj, action = :transmit)
    @paths << obj
    begin
      if obj.is_a?(Tengine::Job::Runtime::Edge)
        if obj.destination.is_a?(Tengine::Job::Runtime::NamedVertex)
          self.call_later do
            cache(obj.destination).send(action, self)
          end
        else
          cache(obj.destination).send(action, self)
        end
      elsif obj.is_a?(Tengine::Job::Runtime::Vertex)
        obj.next_edges.each do |edge|
          # cache_list
          with_paths_backup{ cache(edge).send(action, self) }
        end
      else
        raise Tengine::Job::Runtime::Signal::Error, "leaving unsupported object: #{obj.inspect}"
      end
    rescue Tengine::Job::Runtime::Signal::Error => e
      puts "[#{e.class.name}] #{e.message}\nsignal.paths: #{@paths.inspect}"
      raise e
    end
  end

  def with_paths_backup
    paths_backup = @paths.dup
    begin
      yield if block_given?
    ensure
      @paths = paths_backup
    end
  end

  class Reservation
    attr_reader :source, :event_type_name, :options
    def initialize(source, event_type_name, options = {})
      @source, @event_type_name = source, event_type_name
      @options  = options
      @options[:source_name] ||= source.name_as_resource
    end

    def fire_args
      [@event_type_name, @options]
    end
  end

  def fire(source, event_type_name, properties = {}, options = {})
    case source
    when Tengine::Job::Runtime::Execution then
      properties[:execution_id] ||= source.id.to_s
      properties[:root_jobnet_id] ||= source.root_jobnet.id.to_s
      properties[:root_jobnet_name_path] ||= source.root_jobnet.name_path
      properties[:target_jobnet_id] ||= source.root_jobnet.id.to_s
      properties[:target_jobnet_name_path] ||= source.root_jobnet.name_path
    else
      properties[:execution_id] ||= self.execution.id.to_s
      properties[:root_jobnet_id] ||= source.root.id.to_s
      properties[:root_jobnet_name_path] ||= source.root.name_path
    end
    # デバッグ用
    # properties[:target_jobnet_name] = source.root.vertex(properties[:target_jobnet_id]).name_path
    options ||= {}
    options[:properties] = properties
    properties.each do |key, value|
      if value.is_a?(Moped::BSON::ObjectId)
        properties[key] = value.to_s
      end
    end
    @reservations << Reservation.new(source, event_type_name, options)
  end

  module Transmittable
    # includeするモジュールは以下のメソッドを定義しなければならない
    def transmit(signal); raise NotImplementedError; end
    def activate(signal); raise NotImplementedError; end

    def complete_origin_edge(signal, options = {})
      origin_edge = signal.cache(signal.paths.last)
      origin_edge ||= signal.cache(prev_edges.first)
      begin
        return if options[:except_closed] && origin_edge.closed?
        origin_edge.complete(signal)
      rescue Exception => e
        puts "[#{e.class.name}] #{e.message}\nsignal.paths: #{@paths.inspect}"
        raise e
      end
    end
  end

end
