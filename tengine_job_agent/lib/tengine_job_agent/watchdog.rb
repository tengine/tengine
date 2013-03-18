# -*- coding: utf-8 -*-
require 'tengine_job_agent'

require 'fileutils'
require 'tempfile'
require 'tengine_event'
require 'eventmachine'
require 'uuid'

class TengineJobAgent::Watchdog
  include TengineJobAgent::CommandUtils

  def initialize(logger, args, config = {})
    @uuid = UUID.new.generate
    @logger = logger
    @pid_output = config['pid_output'] || STDOUT
    @pid_path, @program, *@args = *args
    @config = config
  end

  def process
    @logger.info("process start")
    pid, process_status = nil, nil
    with_tmp_outs do |stdout, stderr|
      @logger.debug("before EM.run")
      EM.run do
        @logger.debug("before sender.mq_suite.send :ensures, :connection")
        sender.mq_suite.send :ensures, :connection do
          @logger.debug("before sender.wait_for_connection")
          sender.wait_for_connection do
            @logger.debug("before spawn_process")
            begin
              pid = spawn_process
              File.open(@pid_path, "a"){|f| f.puts(pid)} # 起動したPIDを呼び出し元に返す
              wait_process(pid)
            rescue Exception => e
              File.open(@pid_path, "a"){|f| f.puts("[#{e.class.name}] #{e.message}")}
              @logger.error("[#{e.class.name}] #{e.message}")
              EM.stop
            end
          end
        end
        @logger.debug("after sender.mq_suite.send :ensures, :connection")
      end
      @logger.debug("after EM.run")
    end
    @logger.info("process finished")
  end

  def spawn_process
    @logger.info("spawning process " << [@program, @args].flatten.join(" "))
    options = {
      :out => @stdout.path,
      :err => @stderr.path,
      :pgroup => true}
    pid = Process.spawn(@program, *(@args + [options]))
    @logger.info("spawned process PID: #{pid}")
    return pid
  end

  def wait_process(pid)
    @logger.info("wait_process(#{pid}) begin")
    fire_heartbeat pid do
      @logger.info("begin block for fire_heartbeat(pid)")
      timer = nil
      @logger.info("#{__FILE__}##{__LINE__}")
      int = @config["heartbeat"]["job"]["interval"]
      @logger.info("#{__FILE__}##{__LINE__}")
      if int and int > 0
        @logger.info("before EM.add_periodic_timer")
        timer = EM.add_periodic_timer int do
          fire_heartbeat pid do end # <- rspecを黙らせるための無駄なブロック
        end
      end

      @logger.info("before EM.defer ...")
      EM.defer(lambda {
        @logger.info("before Process.waitpid2 #{pid} ...")
                 Process.waitpid2 pid
        @logger.info("$?: " << $?.inspect)
               }, lambda {|a|
        @logger.info("process finished: " << a[1].exitstatus.inspect)
        EM.cancel_timer timer if timer
        fire_finished(*a)
      })

      @logger.info("after EM.defer ...")
    end
    @logger.info("wait_process(#{pid}) end")
  end

  def fire_finished(pid, process_status)
    exit_status = process_status.exitstatus # killされた場合にnilの可能性がある
    level_key = exit_status == 0 ? :info : :error
    @logger.info("fire_finished starting #{pid} #{level_key}(#{exit_status})")
    event_properties = {
      "execution_id"     => ENV['MM_SCHEDULE_ID'],
      "root_jobnet_id"   => ENV['MM_ROOT_JOBNET_ID'],
      "target_jobnet_id" => ENV['MM_TARGET_JOBNET_ID'],
      "target_job_id"    => ENV['MM_ACTUAL_JOB_ID'],
      "pid" => pid,
      "exit_status" => exit_status,
      "command"   => [@program, @args].flatten.join(" "),
    }
    user_stdout_path = output_filepath("stdout", pid)
    user_stderr_path = output_filepath("stderr", pid)
    FileUtils.cp(@stdout.path, user_stdout_path)
    FileUtils.cp(@stderr.path, user_stderr_path)
    event_properties[:stdout_log] = user_stdout_path
    event_properties[:stderr_log] = user_stderr_path
    if level_key == :error
      event_properties[:message] =
        "Job process failed. STDOUT and STDERR were redirected to files.\n" <<
        "You can see them at '#{user_stdout_path}' and '#{user_stderr_path}'\n" <<
        "on the server '#{ENV['MM_SERVER_NAME']}'"
    end
    sender.fire("finished.process.job.tengine", {
      :key => @uuid,
      :level_key => level_key,
      :source_name => source_name(pid),
      :sender_name => sender_name,
      :properties => event_properties,
    })
    @logger.info("fire_finished complete")
    sender.stop
  end

  def fire_heartbeat pid, &block
    sender.fire("job.heartbeat.tengine", {
      :key => @uuid,
      :level_key => :debug,
      :sender_name => sender_name,
      :source_name => source_name(pid),
      :occurred_at => Time.now,
      :properties => {
        "root_jobnet_id"   => ENV['MM_ROOT_JOBNET_ID'],
        "target_jobnet_id" => ENV['MM_TARGET_JOBNET_ID'],
        "target_job_id"    => ENV['MM_ACTUAL_JOB_ID'],
        "pid" => pid,
        "command"   => [@program, @args].flatten.join(" "),
      },
      :keep_connection => true,
      :retry_count => 0,
    }, &block)
    @logger.debug("fire_heartbeat #{pid}")
  end

  def sender
    @sender ||= Tengine::Event::Sender.new({logger: @logger}.update(@config || {}))
  end

  private
  def sender_name
    @sender_name ||= sprintf "agent:%s/%d/tengine_job_agent", Tengine::Event.host_name, Process.pid
  end

  def source_name pid
    sprintf "job:%s/%d/%s/%s", ENV['MM_SERVER_NAME'], pid, ENV['MM_ROOT_JOBNET_ID'], ENV['MM_ACTUAL_JOB_ID']
  end

  def output_filepath(prefix, pid)
    File.expand_path("#{prefix}-#{pid}.log", @config['log_dir'])
  end

  def with_tmp_outs
    Tempfile.open("stdout-#{Process.pid}.log") do |tmp_stdout|
      @stdout = tmp_stdout
      begin
        Tempfile.open("stderr-#{Process.pid}.log") do |tmp_stderr|
          @stderr = tmp_stderr
          begin
            yield
          ensure
            @stderr = nil
          end
        end
      ensure
        @stdout = nil
      end
    end
  end

end
