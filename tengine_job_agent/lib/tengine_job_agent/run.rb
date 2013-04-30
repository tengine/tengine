# -*- coding: utf-8 -*-
require 'tengine_job_agent'
require 'timeout'
require 'rbconfig'

class TengineJobAgent::Run
  include TengineJobAgent::CommandUtils

  def initialize(logger, args, config = {})
    @logger = logger
    @pid_output = STDOUT
    @error_output = STDERR
    @args = args
    @config = config
    @timeout       = (config[:timeout      ] || ENV["MM_SYSTEM_AGENT_RUN_TIMEOUT"      ] || 600).to_i # seconds
    @timeout_alert = (config[:timeout_alert] || ENV["MM_SYSTEM_AGENT_RUN_TIMEOUT_ALERT"] || 30 ).to_i # seconds
  end

  def process
    validate_environment
    line = nil
    process_spawned = false
    setup_pid_file do |pid_path|
      begin
        timeout(@timeout) do #タイムアウト(秒)
          @logger.info("watchdog process spawning for #{@args.join(' ')}")
          pid = spawn_watchdog(pid_path) # watchdogプロセスをspawnで起動
          @logger.info("watchdog daemon invocation process spawned. PID: #{pid.inspect}")
          File.open(pid_path, "r") do |f|
            sleep(0.1) until line = f.gets
            process_spawned = true
            @logger.info("watchdog process returned first result: #{line.inspect}")
            if line =~ /\A\d+\n?\Z/ # 数字と改行のみで構成されるならそれはPIDのはず。
              @pid_output.puts(line.strip)
              @logger.info("return PID: #{line.strip}")
            else
              f.rewind
              msg = f.read
              @logger.error("error occurred:\n#{msg}")
              @error_output.puts(msg)
              return false
            end
          end
        end
      rescue Timeout::Error => e
        @error_output.puts("[#{e.class.name}] #{e.message}")
        raise e # raiseしたものはTengineJobAgent::Run.processでloggerに出力されるので、ここでは何もしません
      end
    end
  end

  def pid_path
    File.expand_path("pid_for_#{Process.pid}", @config['log_dir'])
  end

  def setup_pid_file
    path = self.pid_path
    @logger.info("pid file creating: #{path}")
    File.open(path, "w"){ } # ファイルをクリア
    @logger.info("pid file created: #{path}")
    begin
      res = yield(path)
      File.delete(path) if File.exist?(path)
      return res
    rescue => e
      @logger.warn("pid file #{path.inspect} is not deleted cause of #{e.class.name}")
      raise
    end
  end

  # 引数にpid_pathを渡してwatchdogを起動します。戻り値は起動したwatchdogのPIDです
  def spawn_watchdog(pid_path)
    # http://doc.ruby-lang.org/ja/1.9.2/method/Kernel/m/spawn.html を参考にしています
    args = @args # + [{:out => stdout_w}] #, :err => stderr_w}]
    watchdog = File.expand_path("../../bin/tengine_job_agent_watchdog", File.dirname(__FILE__))
    # args = [RbConfig.ruby, watchdog, pid_path, *(@args + [{:out => stdout_w, :err => stderr_w}])]
    args = [RbConfig.ruby, watchdog, pid_path, *@args]
    @logger.info("Process.spawn(*#{args.inspect})")
    pid = Process.spawn(*args)
    # ただしこのpidとして起動したプロセスはデーモンプロセスを起動するためのプロセスであり、
    # 即座に終了してします
    @logger.info("spawned watchdog: #{pid}")
    @logger.debug("spawned watchdog:" << `ps aux | grep tengine_job_agent_watchdog | grep -v grep`)
    return pid
  end

  # ジョブ実行時に使用されるRubyが1.8系の場合でもtengine_job_agent_runがエラーを起こさない
  def validate_environment
    if RUBY_VERSION >= "1.9.2"
      @logger.info("RUBY_VERSION is #{RUBY_VERSION}")
    else
      raise "RUBY_VERSION must be >= 1.9.2 but was #{RUBY_VERSION}"
    end
  end

end
