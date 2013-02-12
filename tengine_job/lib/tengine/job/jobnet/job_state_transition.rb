# -*- coding: utf-8 -*-
require 'tengine/job/jobnet'

module Tengine::Job::Jobnet::JobStateTransition
  include Tengine::Job::Jobnet::StateTransition
  include Tengine::Job::Jobnet::JobBaseStateTransition

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  def job_transmit(signal)
    job_base_transmit(signal)
  end
  available(:job_transmit, :on => :initialized,
    :ignored => [:ready, :starting, :running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブ制御ドライバ
  def job_activate(signal)
    case phase_key
    when :initialized then
      # 特別ルール「starting直前stop」
      # initializedに戻されたジョブに対して、:readyになる際にtransmitで送信されたイベントを受け取って、
      # activateしようとすると状態は遷移しないが、後続のエッジを実行する。
      # (エッジを実行しようとした際、エッジがclosedならばそのジョブネットのEndに遷移する。)
      next_edges.first.transmit(signal)
    when :ready then
      complete_origin_edge(signal)
      self.phase_key = :starting
      self.started_at = signal.event.occurred_at
      job_base_ack_to_parent_or_execution(signal)
      # このコールバックはjob_control_driverでupdate_with_lockの外側から
      # 再度呼び出してもらうためにcallbackを設定しています
      signal.callback = lambda{ root.vertex(self.id).activate(signal) }
    when :starting then
      # 実際にSSHでスクリプトを実行
      execution = signal.execution
      execution.signal = signal # ackを呼び返してもらうための苦肉の策
      begin
        run(execution)
      rescue Tengine::Job::ScriptExecutable::Error => e
        signal.callback = lambda do
          job_fail(signal, :message => e.message)
        end
      end
    end
  end
  available(:job_activate, :on => [:initialized, :ready, :starting],
    :ignored => [:running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブ制御ドライバ
  # スクリプトのプロセスのPIDを取得できたときに実行されます
  def job_ack(signal)
    self.executing_pid = (signal.data || {})[:executing_pid]
    self.phase_key = :running
  end
  available(:job_ack, :on => :starting,
    :ignored => [:running, :dying, :success, :error, :stuck])

  def job_finish(signal)
    self.exit_status = signal.event[:exit_status]
    self.finished_at = signal.event.occurred_at
    (self.exit_status.to_s == '0') ?
    job_succeed(signal) :
      job_fail(signal)
  end

  # ハンドリングするドライバ: ジョブ制御ドライバ
  def job_succeed(signal)
    job_base_succeed(signal)
  end
  available :job_succeed, :on => [:starting, :running, :dying, :stuck], :ignored => [:success]

  # ハンドリングするドライバ: ジョブ制御ドライバ
  def job_fail(signal, options = nil)
    job_base_fail(signal, options)
  end
  available :job_fail, :on => [:starting, :running, :dying], :ignored => [:error, :stuck]

  def job_fire_stop(signal)
    signal.fire(self, :"stop.job.job.tengine", {
        :stop_reason => signal.event[:stop_reason],
        :target_jobnet_id => parent.id,
        :target_jobnet_name_path => parent.name_path,
        :target_job_id => self.id,
        :target_job_name_path => self.name_path,
      })
  end
  available :job_fire_stop, :on => [:ready, :starting, :running], :ignored => [:initialized, :dying, :success, :error, :stuck]

  def job_stop(signal, &block)
    case phase_key
    when :ready then
      self.phase_key = :initialized
      self.stopped_at = signal.event.occurred_at
      self.stop_reason = signal.event[:stop_reason]
      next_edges.first.transmit(signal)
    when :starting then
      job = nil
      loop do
        root = self.root.reload # class.find(self.root.id)
        job = root.find_descendant(self.id)
        break unless job.phase_key == :starting
        yield if block_given? # テストの為にyieldしています
        sleep(0.1)
      end
      job.stop(signal, &block)
    when :running then
      self.phase_key = :dying
      self.stopped_at = signal.event.occurred_at
      self.stop_reason = signal.event[:stop_reason]
      signal.callback = lambda do
        kill(signal.execution)
      end
    end
  end
  available :job_stop, :on => [:ready, :starting, :running], :ignored => [:initialized, :dying, :success, :error, :stuck]

  def job_reset(signal, &block)
    self.phase_key = :initialized
    if signal.execution.in_scope?(self)
      next_edges.first.reset(signal)
    end
  end
  available :job_reset, :on => [:initialized, :success, :error, :stuck]

end
