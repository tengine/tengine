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
  attr_accessor :callback

  def initialize(event)
    @event = event
    reset
  end

  def reset
    @paths = []
    @reservations = []
    @data = nil
    @callback = nil
  end

  def execution
    @execution ||= Tengine::Job::Runtime::Execution.find(event[:execution_id])
  end

  def leave(obj, action = :transmit)
    @paths << obj
    begin
      if obj.is_a?(Tengine::Job::Runtime::Edge)
        obj.destination.send(action, self)
      elsif obj.is_a?(Tengine::Job::Runtime::Vertex)
        obj.next_edges.each do |edge|
          with_paths_backup{ edge.send(action, self) }
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
      origin_edge = signal.paths.last
      origin_edge ||= prev_edges.first
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
