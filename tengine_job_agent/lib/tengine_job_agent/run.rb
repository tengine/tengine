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
    @pid_path = File.expand_path("pid_for_#{Process.pid}", @config['log_dir'])
    @timeout       = (config[:timeout      ] || ENV["MM_SYSTEM_AGENT_RUN_TIMEOUT"      ] || 600).to_i # seconds
    @timeout_alert = (config[:timeout_alert] || ENV["MM_SYSTEM_AGENT_RUN_TIMEOUT_ALERT"] || 30 ).to_i # seconds
  end

  def process
    validate_environment
    line = nil
    process_spawned = false
    begin
      timeout(@timeout) do #タイムアウト(秒)
        @logger.info("watchdog process spawning for #{@args.join(' ')}")
        pid = spawn_watchdog # watchdogプロセスをspawnで起動
        @logger.info("watchdog process spawned. PID: #{pid.inspect}")
        File.open(@pid_path, "r") do |f|
          sleep(0.1) until line = f.gets
          process_spawned = true
          @logger.info("watchdog process returned first result: #{line.inspect}")
          if line =~ /\A\d+\n?\Z/ # 数字と改行のみで構成されるならそれはPIDのはず。
            @pid_output.puts(line.strip)
            @logger.info("return PID: #{pid.inspect}")
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

  # 引数に@pid_pathを渡してwatchdogを起動します。戻り値は起動したwatchdogのPIDです
  def spawn_watchdog
    @logger.info("pid file creating: #{@pid_path}")
    File.open(@pid_path, "w"){ } # ファイルをクリア
    @logger.info("pid file created: #{@pid_path}")
    # http://doc.ruby-lang.org/ja/1.9.2/method/Kernel/m/spawn.html を参考にしています
    args = @args # + [{:out => stdout_w}] #, :err => stderr_w}]
    watchdog = File.expand_path("../../bin/tengine_job_agent_watchdog", File.dirname(__FILE__))
    @logger.info("spawning watchdog: #{@pid_path}")
    pid = Process.spawn(RbConfig.ruby, watchdog, @pid_path, *args)
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
