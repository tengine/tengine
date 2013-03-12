# -*- coding: utf-8 -*-

require 'tengine/core'
require 'tengine/job/runtime'

class Tengine::Job::Runtime::Execution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Job::Runtime::Executable
  include Tengine::Core::CollectionAccessible

  field :target_actual_ids, :type => Array
  array_text_accessor :target_actual_ids

  field :preparation_command, :type => String
  field :actual_base_timeout_alert, :type => Integer
  field :actual_base_timeout_termination, :type => Integer
  field :estimated_time, :type => Integer
  field :keeping_stdout, :type => Boolean
  field :keeping_stderr, :type => Boolean

  # 1.0.0で想定している実行は 再実行でない実行時にスポット実行は想定していないが
  # そういう利用も考えられるので、対応できるように属性はわけておきます
  field :retry, :type => Boolean, :default => false # 再実行かどうか
  field :spot , :type => Boolean, :default => false # スポット実行かどうか

  belongs_to :root_jobnet, :class_name => "Tengine::Job::Runtime::RootJobnet", :index => true, :inverse_of => :executions

  attr_accessor :signal # runを実行して、ackを返す際に一時的にsignalを記録しておく属性です。それ以外には使用しないでください。

  # 実開始日時から求める予定終了時刻
  def actual_estimated_end
    return nil unless started_at
    (started_at + (estimated_time || 0)).utc
  end

  def name_as_resource
    root_jobnet.name_as_resource.sub(/^job:/, 'execution:')
  end

  def target_actuals
    r = self.root_jobnet
    if target_actual_ids.nil? || target_actual_ids.empty?
      [r]
    else
      target_actual_ids.map do |target_actual_id|
        r.vertex(target_actual_id)
      end
    end
  end

  def scope_root
    unless @scope_root
      actual = target_actuals.first
      @scope_root = spot ? actual : actual.parent || actual
      unless @scope_root
        raise "@scope_root must not be nil"
      end
    end
    @scope_root
  end

  def in_scope?(vertex)
    return false if vertex.nil?
    return true if target_actual_ids.nil? || target_actual_ids.empty?
    (vertex.id == scope_root.id) || vertex.ancestors.map(&:id).include?(scope_root.id)
  end

  def transmit(signal)
    case phase_key
    when :initialized then
      self.phase_key = :ready
      signal.call_later do
        if self.retry
          target_actuals.each do |target|
            signal.call_later{ signal.cache(target).reset(signal) }
          end
        end
        signal.call_later do
          Tengine.logger.info("=" * 50)
          activate(signal)
        end
      end
    else
      raise "Unsupported phase_key for transmit: #{phase_key.inspect}"
    end
  end

  def activate(signal)
    case phase_key
    when :ready then
      self.phase_key = :starting
      if self.retry
        target_actuals.each do |target|
          target.transmit(signal)
        end
      else
        root_jobnet.transmit(signal)
      end
    else
      raise "Unsupported phase_key for activate: #{phase_key.inspect}"
    end
  end

  def ack(signal)
    case phase_key
    when :ready then
      raise Tengine::Job::Runtime::Executable::PhaseError, "ack not available on #{phase_key.inspect}"
    when :starting then
      self.phase_key = :running
    end
  end

  def succeed(signal)
    case phase_key
    when :initialized, :ready, :error then
      raise Tengine::Job::Runtime::Executable::PhaseError, "succeed not available on #{phase_key.inspect}"
    when :starting, :running, :dying, :stuck then
      self.phase_key = :success
      signal.fire(self, :"success.execution.job.tengine")
    end
  end

  def fail(signal)
    case phase_key
    when :initialized, :ready, :success then
      raise Tengine::Job::Runtime::Executable::PhaseError, "fail not available on #{phase_key.inspect}"
    when :starting, :running, :dying, :stuck then
      self.phase_key = :error
      signal.fire(self, :"error.execution.job.tengine")
    end
  end

#   def fire_stop(signal)
#     return if self.phase_key == :initialized
#     signal.fire(self, :"stop.execution.job.tengine", {
#         :execution_id => self.id,
#         :root_jobnet_id => root_jobnet.id,
#         :target_jobnet_id => root_jobnet.id,
#       })
#   end

  def stop(signal)
    self.phase_key = :dying
    root_jobnet.fire_stop(signal)
  end

end
