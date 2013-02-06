# -*- coding: utf-8 -*-
require 'tengine/job'
require 'tengine/resource/net_ssh'

# ジョブとして実際にスクリプトを実行する処理をまとめるモジュール。
# Tengine::Job::JobnetActualと、Tengine::Job::ScriptActualがincludeします
module Tengine::Job::ScriptExecutable
  extend ActiveSupport::Concern

  class Error < StandardError
  end

  included do
    include Tengine::Core::CollectionAccessible

    field :executing_pid, :type => String # 実行しているプロセスのPID
    field :exit_status  , :type => String # 終了したプロセスが返した終了ステータス
    field :error_messages, :type => Array # エラーになった場合のメッセージを保持する配列。再実行時に追加される場合は末尾に追加されます。
    array_text_accessor :error_messages, :delimeter => "\n"
  end

  def run(execution)
    return ack(@acked_pid) if @acked_pid
    cmd = build_command(execution)
    # puts "cmd:\n" << cmd
    execute(cmd) do |ch, data|
      if signal = execution.signal
        # signal.data = {:executing_pid => data.strip}
        # ack(signal)
        pid = data.strip
        signal.callback = lambda do
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
      c = ssh.open_channel do |channel|
        # channel.exec("bash -l") do |shell_ch, success|
        channel.request_pty do |shell_ch, success|
        Tengine.logger.info("now exec on ssh: " << cmd)
        shell_ch.exec(cmd.force_encoding("binary")) do |ch, success|
          raise Error, "could not execute command" unless success

          ch.on_close do |ch|
            # puts "ch is closing!"
          end

          ch.on_data do |ch, data|
            Tengine.logger.debug("got stdout: #{data}")
            yield(ch, data) if block_given?
          end

          ch.on_extended_data do |ch, type, data|
            self.error_messages ||= []
            self.error_messages += [data]
            raise Error, "Failure to execute #{self.name_path} via SSH: #{data}"
          end
        end
        end
      end
      c.wait
    end
  rescue Tengine::Job::ScriptExecutable::Error
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
    if is_a?(Tengine::Job::Jobnet) && (jobnet_type_key == :hadoop_job_run)
      mm_env << ' ' << hadoop_job_env
    end
    result << "export #{mm_env}"
    template_root = root_or_expansion.template
    if template_root
      template_job = template_root.vertex_by_name_path(self.name_path_until_expansion)
      unless template_job
        raise "job not found #{self.name_path_until_expansion.inspect} in #{template_root.inspect}"
      end
      key = Tengine::Job::DslLoader.template_block_store_key(template_job, :preparation)
      preparation_block = Tengine::Job::DslLoader.template_block_store[key]
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
    if rjt = root.template
      t = rjt.find_descendant_by_name_path(self.name_path)
      unless t
        template_name_parts = self.name_path_until_expansion.split(Tengine::Job::NamePath::SEPARATOR).select{|s| !s.empty?}
        root_jobnet_name = template_name_parts.first
        if rjt = Tengine::Job::RootJobnetTemplate.find_by_name(root_jobnet_name, :version => rjt.dsl_version)
          t = rjt.find_descendant_by_name_path(self.name_path_until_expansion)
          raise "template job #{path.inspect} not found in #{rjt.inspect}" unless t
        else
          raise "Tengine::Job::RootJobnetTemplate not found #{self.name_path_until_expansion.inspect}"
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
    s = children.select{|c| c.is_a?(Tengine::Job::Jobnet) && (c.jobnet_type_key == :hadoop_job)}.
      map{|c| "#{c.name}\\t#{c.id.to_s}\\n"}.join
    "MM_HADOOP_JOBS=\"#{s}\""
  end


end
