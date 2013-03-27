# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

require 'tengine/resource/net_ssh'

# ルートジョブネットを他のジョブネット内に展開するための特殊なテンプレート用Vertex。
class Tengine::Job::Runtime::SshJob < Tengine::Job::Runtime::JobBase

  class Error < StandardError
  end

  include Tengine::Core::CollectionAccessible
  include Tengine::Job::Template::SshJob::Settings

  include Tengine::Job::Runtime::StateTransition

  field :executing_pid, :type => String # 実行しているプロセスのPID
  field :exit_status  , :type => String # 終了したプロセスが返した終了ステータス
  field :error_messages, :type => Array # エラーになった場合のメッセージを保持する配列。再実行時に追加される場合は末尾に追加されます。
  array_text_accessor :error_messages, :delimeter => "\n"

  before_validation :prepare_server_and_credential

  def prepare_server_and_credential
    if t = template_vertex
      self.server_name = t.actual_server_name if server_name.blank?
      self.credential_name = t.actual_credential_name if credential_name.blank?
    end
  end

  def run(execution)
    return ack(@acked_pid) if @acked_pid
    cmd = build_command(execution)
    # puts "cmd:\n" << cmd
    execute(cmd) do |ch, data|
      pid = data.strip
      if pid =~ /^\d+$/
        Tengine.logger.info("got pid: #{pid.inspect}")
      else
        add_error_message("expected numeric charactors but got: " << data.inspect)
        raise Error, "Failure to execute #{self.name_path} via SSH. expected numeric charactors but got: #{data}"
      end

      if signal = execution.signal
        signal.call_later do
          signal.data = {:executing_pid => pid}

          # このブロック内の処理はupdate_with_lockによって複数回実行されることがあります。
          # 1回目と同じリロードされていないオブジェクトを2回目以降に使用すると、1回目の変更が残っているので
          # そのオブジェクトに対して処理を行うのはNGです。
          # self.ack(signal) # これはNG

          # このブロックが実行されるたびに、rootからselfと同じidのオブジェクトを新たに取得する必要があります。
          job = root.vertex(self.id)
          job.ack(signal)
        end
      end
    end
  rescue Exception => e
    Tengine.logger.error("[#{e.class}] #{e.message}\n  " << e.backtrace.join("\n  "))
    raise
  end

  def execute(cmd)
    raise "actual_server not found for #{self.name_path.inspect}" unless actual_server
    Tengine.logger.info("connecting to #{actual_server.hostname_or_ipv4}")
    port = actual_server.properties["ssh_port"] || 22
    keys_only = actual_credential.auth_type_cd == :ssh_public_key
    Net::SSH.start(actual_server.hostname_or_ipv4, actual_credential, :port => port, :logger => Tengine.logger, :keys_only => keys_only) do |ssh|
      # see http://net-ssh.github.com/ssh/v2/api/classes/Net/SSH/Connection/Channel.html
      c = ssh.open_channel do |ch0|
        ch0.request_pty do |channel, success|
          raise Error, "failed to request_pty" unless success

        buffer = []
        actual_cmd = "echo $PS1"
        prompt = nil
        count = 0
        exiting = false

        channel.exec("#{ENV['SHELL']} -l") do |shell_ch, success|
          raise Error, "failed to \"#{ENV['SHELL']} -l\"" unless success

          shell_ch[:data] = ""

shell_ch.on_process do |ch|
  while shell_ch[:data] =~ %r!^.*?\n!
    puts "=" * 100
    puts buffer.inspect
    puts "-" * 100
    buffer = []

    output = $&

    puts output
    shell_ch[:data] = $'

    unless exiting
    if prompt.nil?
      if (output =~ %r!<<<(.+)>>>!) && ($1 != "$PS1")
        prompt = $1

        actual_cmd = cmd.force_encoding("binary")
        Tengine.logger.info("now exec on ssh: " << cmd)
        puts("now exec on ssh: " << cmd)
        shell_ch.send_data(actual_cmd + "\n")

      end
    else
      count += 1
puts "count: #{count}"
      if count > 1
        yield(ch, output) if block_given?
        exiting = true
        shell_ch.send_data("exit\n")
      end
    end
    end
  end
end

          shell_ch.on_data do |ch, data|
            shell_ch[:data] << data
            buffer << data
            Tengine.logger.info("got STDOUT data: #{data.inspect}")
          end

          shell_ch.on_extended_data do |ch, type, data|
            add_error_message(data)
            raise Error, "Failure to execute #{self.name_path} via SSH: #{data}"
          end

          Tengine.logger.info("now exec on ssh: echo $PS1")
          shell_ch.send_data("echo \"<<<$PS1>>>\"\n")

        end
        end
      end
      c.wait
    end
  rescue Tengine::Job::Runtime::SshJob::Error
    raise
  rescue Mongoid::Errors::DocumentNotFound, SocketError, Net::SSH::AuthenticationFailed => src
    error = Error.new("[#{src.class.name}] #{src.message}")
    error.set_backtrace(src.backtrace)
    raise error
  rescue Exception
    # puts "[#{$!.class.name}] #{$!.message}"
    raise
  end

  def kill(execution)
    lines = []

    if self.executing_pid.blank?
      Tengine.logger.warn("PID is blank when kill!!\n#{self.inspect}\n  " << caller.join("\n  "))
    end

    cmd = executable_command("tengine_job_agent_kill %s %d %s" % [
        self.executing_pid,
        self.actual_killing_signal_interval,
        self.actual_killing_signals.join(","),
      ])
    lines << cmd
    cmd = lines.join(' && ')
    execute(cmd)
  end

#   def ack(pid)
#     @acked_pid = pid
#     self.executing_pid = pid
#     self.phase_key = :running
#     self.previous_edges.each{|edge| edge.status_key = :transmitted}
#   end

  def build_command(execution)
    result = []
    mm_env = build_mm_env(execution).map{|k,v| "#{k}=#{v}"}.join(" ")
    # Hadoopジョブの場合は環境変数をセットする
    if is_a?(Tengine::Job::Runtime::Jobnet) && (jobnet_type_key == :hadoop_job_run)
      mm_env << ' ' << hadoop_job_env
    end
    result << "export #{mm_env}"
    template_root = (parent ? root_or_expansion.template : nil)
    if template_root
      template_job = template_root.vertex_by_name_path(self.name_path_until_expansion)
      unless template_job
        raise "job not found #{self.name_path_until_expansion.inspect} in #{template_root.inspect}"
      end
      key = Tengine::Job::Dsl::Loader.template_block_store_key(template_job, :preparation)
      preparation_block = Tengine::Job::Dsl::Loader.template_block_store[key]
      if preparation_block
        preparation = instance_eval(&preparation_block)
        unless preparation.blank?
          result << preparation
        end
      end
    end
    unless execution.preparation_command.blank?
      result << execution.preparation_command
    end
    # cmdはユーザーが設定したスクリプトを組み立てたもので、
    # プロセスの監視／強制停止のためにtengine_job_agent/bin/tengine_job_agent_run
    # からこれらを実行させるためにはcmdを編集します。
    # tengine_job_agent_runは、標準出力に監視対象となる起動したプロセスのPIDを出力します。
    runner_path = ENV["MM_RUNNER_PATH"] || executable_command("tengine_job_agent_run")
    runner_option = ""
    # 実装するべきか要検討
    # runner_option << " --stdout" if execution.keeping_stdout
    # runner_option << " --stderr" if execution.keeping_stderr
    # script = "#{runner_path}#{runner_option} -- #{self.script}" # runnerのオプションを指定する際は -- の前に設定してください
    script = "#{runner_path}#{runner_option} #{self.script}" # runnerのオプションを指定する際は -- の前に設定してください
    result << script
    result.join(" && ")
  end

  def executable_command(command)
    if prefix = ENV["MM_CMD_PREFIX"]
      "#{prefix} #{command}"
    else
      command
    end
  end

  # MMから実行されるシェルスクリプトに渡す環境変数のHashを返します。
  # MM_ACTUAL_JOB_ID                : 実行される末端のジョブのMM上でのID
  # MM_ACTUAL_JOB_ANCESTOR_IDS      : 実行される末端のジョブの祖先のMM上でのIDをセミコロンで繋げた文字列 (テンプレートジョブ単位)
  # MM_FULL_ACTUAL_JOB_ANCESTOR_IDS : 実行される末端のジョブの祖先のMM上でのIDをセミコロンで繋げた文字列 (expansionから展開した単位)
  # MM_ACTUAL_JOB_NAME_PATH         : 実行される末端のジョブのname_path
  # MM_ACTUAL_JOB_SECURITY_TOKEN    : 公開API呼び出しのためのセキュリティ用のワンタイムトークン
  # MM_TEMPLATE_JOB_ID              : テンプレートジョブ(=実行される末端のジョブの元となったジョブ)のID
  # MM_TEMPLATE_JOB_ANCESTOR_IDS    : テンプレートジョブの祖先のMM上でのIDをセミコロンで繋げたもの
  # MM_SCHEDULE_ID                  : 実行スケジュールのID
  # MM_SCHEDULE_ESTIMATED_TIME      : 実行スケジュールの見積り時間。単位は分。
  # MM_SCHEDULE_ESTIMATED_END       : 実行スケジュールの見積り終了時刻をYYYYMMDDHHMMSS式で。(できればISO 8601など、タイムゾーンも表現できる標準的な形式の方が良い？)
  # MM_MASTER_SCHEDULE_ID           : マスタースケジュールがあればそのID。マスタースケジュールがない場合は環境変数は指定されません。
  #
  # 未実装
  # MM_FAILED_JOB_ID                : ジョブが失敗した場合にrecoverやfinally内のジョブを実行時に設定される、失敗したジョブのMM上でのID。
  # MM_FAILED_JOB_ANCESTOR_IDS      : ジョブが失敗した場合にrecoverやfinally内のジョブを実行時に設定される、失敗したジョブの祖先のMM上でのIDをセミコロンで繋げた文字列。
  def build_mm_env(execution)
    result = {
      "MM_SERVER_NAME" => actual_server_name,  # [Tengineの仕様として追加] ジョブの実行サーバ名を設定
      "MM_ROOT_JOBNET_ID" => root.id.to_s,
      "MM_TARGET_JOBNET_ID" => (parent ? parent.id.to_s : nil),
      "MM_ACTUAL_JOB_ID" => id.to_s,
      "MM_ACTUAL_JOB_ANCESTOR_IDS" => '"%s"' % ancestors_until_expansion.map(&:id).map(&:to_s).join(';'),
      "MM_FULL_ACTUAL_JOB_ANCESTOR_IDS" => '"%s"' % ancestors.map(&:id).map(&:to_s).join(';'),
      "MM_ACTUAL_JOB_NAME_PATH" => name_path.dump,
      "MM_ACTUAL_JOB_SECURITY_TOKEN" => "", # TODO トークンの生成
      "MM_SCHEDULE_ID" => execution.id.to_s,
      "MM_SCHEDULE_ESTIMATED_TIME" => execution.estimated_time,
    }
    if estimated_end = execution.actual_estimated_end
      result["MM_SCHEDULE_ESTIMATED_END"] = estimated_end.strftime("%Y%m%d%H%M%S")
    end
    if rjt = (parent ? root.template : nil)
      t = rjt.find_descendant_by_name_path(self.name_path)
      unless t
        template_name_parts = self.name_path_until_expansion.split(Tengine::Job::Structure::NamePath::SEPARATOR).select{|s| !s.empty?}
        root_jobnet_name = template_name_parts.first
        if rjt = Tengine::Job::Template::RootJobnet.find_by_name(root_jobnet_name, :version => rjt.dsl_version)
          t = rjt.find_descendant_by_name_path(self.name_path_until_expansion)
          raise "template job #{name_path.inspect} not found in #{rjt.inspect}" unless t
        else
          raise "Tengine::Job::Template::RootJobnet not found #{self.name_path_until_expansion.inspect}"
        end
      end
      result.update({
          "MM_TEMPLATE_JOB_ID" => t.id.to_s,
          "MM_TEMPLATE_JOB_ANCESTOR_IDS" => '"%s"' % t.ancestors.map(&:id).map(&:to_s).join(';'),
      })
    end
    # if ms = execution.master_schedule
    #   result.update({
    #       "MM_MASTER_SCHEDULE_ID" => ms.id.to_s,
    #   })
    # end
    result
  end

  def hadoop_job_env
    s = children.select{|c| c.is_a?(Tengine::Job::Runtime::Jobnet) && (c.jobnet_type_key == :hadoop_job)}.
      map{|c| "#{c.name}\\t#{c.id.to_s}\\n"}.join
    "MM_HADOOP_JOBS=\"#{s}\""
  end

  def add_error_message(msg)
    self.error_messages ||= []
    self.error_messages += [msg]
  end


  ## 状態遷移アクション

  # ハンドリングするドライバ: ジョブネット制御ドライバ
  def transmit(signal)
    self.phase_key = :ready
    self.started_at = signal.event.occurred_at
    signal.fire(self, :"start.job.job.tengine", {
        :target_jobnet_id => parent.id,
        :target_jobnet_name_path => parent.name_path,
        :target_job_id => self.id,
        :target_job_name_path => self.name_path,
      })
  end
  available(:transmit, :on => :initialized,
    :ignored => [:ready, :starting, :running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブ制御ドライバ
  def activate(signal)
    case phase_key
    when :initialized then
      # 特別ルール「starting直前stop」
      # initializedに戻されたジョブに対して、:readyになる際にtransmitで送信されたイベントを受け取って、
      # activateしようとすると状態は遷移しないが、後続のエッジを実行する。
      # (エッジを実行しようとした際、エッジがclosedならばそのジョブネットのEndに遷移する。)
      next_edges.first.transmit(signal)
    when :ready then
      self.phase_key = :starting
      self.started_at = signal.event.occurred_at

      signal.call_later do
        complete_origin_edge(signal)
        execution = signal.execution
        if execution.retry
          if execution.target_actual_ids.include?(self.id.to_s)
            execution.ack(signal)
          elsif execution.target_actuals.map{|t| t.parent.id.to_s if t.parent }.include?(self.parent.id.to_s)
            # 自身とTengine::Job::Runtime::Execution#target_actual_idsに含まれるジョブ／ジョブネットと親が同じならば、ackしない
          else
            parent.ack(signal)
          end
        else
          parent.ack(signal) # 再実行でない場合
        end
        # このコールバックはjob_control_driverでupdate_with_lockの外側から
        # 再度呼び出してもらうためにcallbackを設定しています
        signal.call_later do
          # 実際にSSHでスクリプトを実行
          execution = signal.execution
          execution.signal = signal # ackを呼び返してもらうための苦肉の策
          begin
            run(execution)
          rescue Tengine::Job::Runtime::SshJob::Error => e
            Tengine.logger.warn("error on run\nerror: #{e.inspect}\njob: #{self.inspect}\nexecution: #{execution.inspect}")
            signal.call_later do
              self.fail(signal, :message => e.message)
            end
          end
        end
      end
    when :starting then
      raise "something wrong! #{self.inspect}"
    end
  end
  available(:activate, :on => [:initialized, :ready, :starting],
    :ignored => [:running, :dying, :success, :error, :stuck])

  # ハンドリングするドライバ: ジョブ制御ドライバ
  # スクリプトのプロセスのPIDを取得できたときに実行されます
  def ack(signal)
    self.executing_pid = (signal.data || {})[:executing_pid]
    self.phase_key = :running
  end
  available(:ack, :on => :starting,
    :ignored => [:running, :dying, :success, :error, :stuck])

  def finish(signal)
    self.exit_status = signal.event[:exit_status]
    self.finished_at = signal.event.occurred_at
    (self.exit_status.to_s == '0') ?
    succeed(signal) :
      fail(signal)
  end

  # ハンドリングするドライバ: ジョブ制御ドライバ
  def succeed(signal)
    self.phase_key = :success
    self.finished_at = signal.event.occurred_at
    signal.fire(self, :"success.job.job.tengine", {
        :exit_status => self.exit_status,
        :target_jobnet_id => parent.id,
        :target_jobnet_name_path => parent.name_path,
        :target_job_id => self.id,
        :target_job_name_path => self.name_path,
      })
  end
  available :succeed, :on => [:starting, :running, :dying, :stuck], :ignored => [:success]

  # ハンドリングするドライバ: ジョブ制御ドライバ
  def fail(signal, options = nil)
    self.phase_key = :error
    if msg = signal.event[:message]
      add_error_message(msg)
    end
    if options && (msg = options[:message])
      add_error_message(msg)
    end
    self.finished_at = signal.event.occurred_at
    event_options = {
      :exit_status => self.exit_status,
      :target_jobnet_id => parent.id,
      :target_jobnet_name_path => parent.name_path,
      :target_job_id => self.id,
      :target_job_name_path => self.name_path,
    }
    event_options.update(options) if options
    signal.fire(self, :"error.job.job.tengine", event_options)
  end
  available :fail, :on => [:starting, :running, :dying], :ignored => [:error, :stuck]

  def fire_stop(signal)
    signal.fire(self, :"stop.job.job.tengine", {
        :stop_reason => signal.event[:stop_reason],
        :target_jobnet_id => parent.id,
        :target_jobnet_name_path => parent.name_path,
        :target_job_id => self.id,
        :target_job_name_path => self.name_path,
      })
  end
  available :fire_stop, :on => [:ready, :starting, :running], :ignored => [:initialized, :dying, :success, :error, :stuck]

  def stop(signal, &block)
    case phase_key
    when :ready then
      self.phase_key = :initialized
      self.stopped_at = signal.event.occurred_at
      self.stop_reason = signal.event[:stop_reason]
      next_edges.first.transmit(signal)
    when :starting then
      job = nil
      loop do
        # root = self.root.reload # class.find(self.root.id)
        # job = root.find_descendant(self.id)
        job = self.class.find(self.id)
        break unless job.phase_key == :starting
        yield if block_given? # テストの為にyieldしています
        sleep(0.1)
      end
      job.stop(signal, &block)
    when :running then
      self.phase_key = :dying
      self.stopped_at = signal.event.occurred_at
      self.stop_reason = signal.event[:stop_reason]
      signal.call_later do
        kill(signal.execution)
      end
    end
  end
  available :stop, :on => [:ready, :starting, :running], :ignored => [:initialized, :dying, :success, :error, :stuck]

  def reset(signal, &block)
    self.phase_key = :initialized
    reset_followings(signal)
  end
  available :reset, :on => [:initialized, :ready, :success, :error, :stuck]

end
