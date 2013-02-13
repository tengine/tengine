# -*- coding: utf-8 -*-
require 'tengine/job/jobnet'

module Tengine::Job::Jobnet::JobnetStateTransition
  include Tengine::Job::Jobnet::StateTransition

  # ハンドリングするドライバ: ジョブネット制御ドライバ or ジョブ起動ドライバ
  def jobnet_transmit(signal)
    self.phase_key = :ready
    signal.fire(self, :"start.jobnet.job.tengine", {
        :target_jobnet_id => self.id,
        :target_jobnet_name_path => self.name_path,
      })
  end
  available(:jobnet_transmit, :on => :initialized,
    :ignored => [:ready, :starting, :running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  def jobnet_activate(signal)
    self.phase_key = :starting
    self.started_at = signal.event.occurred_at
    complete_origin_edge(signal) if prev_edges && !prev_edges.empty?
    (parent || signal.execution).ack(signal)
    signal.paths << self
    self.start_vertex.transmit(signal)
  end
  available(:jobnet_activate, :on => :ready,
    :ignored => [:starting, :running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  # このackは、子要素のTengine::Job::Start#activateから呼ばれます
  def jobnet_ack(signal)
    self.phase_key = :running
  end
  available(:jobnet_ack, :on => [:initialized, :ready, :starting],
    :ignored => [:running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  # このackは、子要素のTengine::Job::End#activateから呼ばれます
  def jobnet_finish(signal)
    edge = end_vertex.prev_edges.first
    edge.closed? ?
    jobnet_fail(signal) :
      jobnet_succeed(signal)
  end

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  def jobnet_succeed(signal)
    self.phase_key = :success
    self.finished_at = signal.event.occurred_at
    signal.fire(self, :"success.jobnet.job.tengine", {
        :target_jobnet_id => self.id,
        :target_jobnet_name_path => self.name_path,
      })
  end
  available :jobnet_succeed, :on => [:starting, :running, :dying, :stuck, :error], :ignored => [:success]

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  def jobnet_fail(signal)
    return if self.edges.any?(&:alive?)
    self.phase_key = :error
    self.finished_at = signal.event.occurred_at
    signal.fire(self, :"error.jobnet.job.tengine", {
        :target_jobnet_id => self.id,
        :target_jobnet_name_path => self.name_path,
      })
  end
  available :jobnet_fail, :on => [:starting, :running, :dying, :success], :ignored => [:error, :stuck]

  def jobnet_fire_stop(signal)
    return if self.phase_key == :initialized
    signal.fire(self, :"stop.jobnet.job.tengine", {
        :target_jobnet_id => self.id,
        :target_jobnet_name_path => self.name_path,
        :stop_reason => signal.event[:stop_reason]
      })
  end

  def jobnet_stop(signal)
    self.phase_key = :dying
    self.stopped_at = signal.event.occurred_at
    self.stop_reason = signal.event[:stop_reason]
    close(signal)
    children.each do |child|
      child.fire_stop(signal) if child.respond_to?(:fire_stop)
    end
  end
  available :jobnet_stop, :on => [:initialized, :ready, :starting, :running], :ignored => [:dying, :success, :error, :stuck]

  def close(signal)
    self.edges.each{|edge| edge.close(signal)}
  end


  def jobnet_reset(signal, &block)
    # children.each{|c| c.reset(signal) }
    self.phase_key = :initialized
    if s = start_vertex
      s.reset(signal)
    end
    if edge = (next_edges || []).first
      edge.reset(signal)
    end
  rescue Exception => e
    puts "#{self.name_path} [#{e.class}] #{e.message}"
    raise
  end
  available :jobnet_reset, :on => [:initialized, :success, :error, :stuck]

end
