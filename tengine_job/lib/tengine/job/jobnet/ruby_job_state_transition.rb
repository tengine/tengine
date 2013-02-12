# -*- coding: utf-8 -*-
require 'tengine/job/jobnet'

module Tengine::Job::Jobnet::RubyJobStateTransition
  include Tengine::Job::Jobnet::StateTransition
  include Tengine::Job::Jobnet::JobBaseStateTransition

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  def ruby_job_transmit(signal)
    job_base_transmit(signal)
  end
  available(:ruby_job_transmit, :on => :initialized,
    :ignored => [:ready, :running, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブ制御ドライバ
  def ruby_job_activate(signal)
    case phase_key
    when :ready then
      complete_origin_edge(signal)
      self.phase_key = :running
      self.started_at = signal.event.occurred_at
      job_base_ack_to_parent_or_execution(signal)
      # このコールバックはjob_control_driverでupdate_with_lockの外側から
      # 再度呼び出してもらうためにcallbackを設定しています
      signal.callback = lambda{ root.vertex(self.id).activate(signal) }
    when :running then
      signal.callback = lambda do
        Tengine::Job::RubyJob.run(self, signal, conductor)
      end
    end
  end
  available(:ruby_job_activate, :on => [:ready, :running],
    :ignored => [:dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブ制御ドライバ
  # スクリプトのプロセスのPIDを取得できたときに実行されます
  def ruby_job_ack(signal)
    raise Tengine::Job::Executable::PhaseError, "\#{name_path} \#{self.class.name}##{method_name} not available for ruby_job"
  end

  # 使用されないはずなのでコメントアウト
  # def ruby_job_finish(signal)
  # end

  # ハンドリングするドライバ: ジョブ制御ドライバ
  def ruby_job_succeed(signal, options = nil)
    job_base_succeed(signal, options)
  end
  available :ruby_job_succeed, :on => [:starting, :running, :dying, :stuck], :ignored => [:success]

  # ハンドリングするドライバ: ジョブ制御ドライバ
  def ruby_job_fail(signal, options = nil)
    job_base_fail(signal, options)
  end
  available :ruby_job_fail, :on => [:starting, :running, :dying, :stuck], :ignored => [:error]

  def ruby_job_fire_stop(signal)
    signal.fire(self, :"stop.job.job.tengine", {
        :stop_reason => signal.event[:stop_reason],
        :target_jobnet_id => parent.id,
        :target_jobnet_name_path => parent.name_path,
        :target_job_id => self.id,
        :target_job_name_path => self.name_path,
      })
  end
  available :ruby_job_fire_stop, :on => [:ready], :ignored => [:initialized, :dying, :running, :success, :error, :stuck]

  def ruby_job_stop(signal, &block)
    case phase_key
    when :ready then
      self.phase_key = :initialized
      self.stopped_at = signal.event.occurred_at
      self.stop_reason = signal.event[:stop_reason]
      next_edges.first.transmit(signal)
    end
  end
  available :ruby_job_stop, :on => [:ready], :ignored => [:initialized, :running, :dying, :success, :error, :stuck]

  def ruby_job_reset(signal, &block)
    job_base_reset(signal, &block)
  end
  available :ruby_job_reset, :on => [:initialized, :success, :error, :stuck]

end
