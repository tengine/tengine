# -*- coding: utf-8 -*-
require 'tengine/job/jobnet'

module Tengine::Job::Jobnet::JobBaseStateTransition

  def job_base_transmit(signal)
    self.phase_key = :ready
    self.started_at = signal.event.occurred_at
    signal.fire(self, :"start.job.job.tengine", {
        :target_jobnet_id => parent.id,
        :target_jobnet_name_path => parent.name_path,
        :target_job_id => self.id,
        :target_job_name_path => self.name_path,
      })
  end

  def job_base_ack_to_parent_or_execution(signal)
    execution = signal.execution
    if execution.retry
      if execution.target_actual_ids.include?(self.id.to_s)
        execution.ack(signal)
      elsif execution.target_actuals.map{|t| t.parent.id.to_s if t.parent }.include?(self.parent.id.to_s)
        # 自身とTengine::Job::Execution#target_actual_idsに含まれるジョブ／ジョブネットと親が同じならば、ackしない
      else
        parent.ack(signal)
      end
    else
      parent.ack(signal) # 再実行でない場合
    end
  end

  def job_base_succeed(signal, options = nil)
    self.phase_key = :success
    self.finished_at = signal.event.occurred_at
    event_options = {
      :target_jobnet_id => parent.id,
      :target_jobnet_name_path => parent.name_path,
      :target_job_id => self.id,
      :target_job_name_path => self.name_path,
    }
    event_options.update(options) if options
    case self.jobnet_type_key
    when :ruby_job then
    else
      event_options[:exit_status] = self.exit_status
    end
    event_options.update(options) if options
    signal.fire(self, :"success.job.job.tengine", event_options)
  end

  def job_base_fail(signal, options = nil)
    self.phase_key = :error
    if msg = signal.event[:message]
      self.error_messages ||= []
      self.error_messages += [msg]
    end
    if options && (msg = options[:message])
      self.error_messages ||= []
      self.error_messages += [msg]
    end
    self.finished_at = signal.event.occurred_at
    event_options = {
      :target_jobnet_id => parent.id,
      :target_jobnet_name_path => parent.name_path,
      :target_job_id => self.id,
      :target_job_name_path => self.name_path,
    }
    case self.jobnet_type_key
    when :ruby_job then
    else
      event_options[:exit_status] = self.exit_status
    end
    event_options.update(options) if options
    signal.fire(self, :"error.job.job.tengine", event_options)
  end


  def job_base_reset(signal, &block)
    self.phase_key = :initialized
    if signal.execution.in_scope?(self)
      next_edges.first.reset(signal)
    end
  end

end
