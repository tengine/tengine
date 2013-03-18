# -*- coding: utf-8 -*-
require 'fileutils'
require 'tmpdir'

class TestRabbitmq
  class << self
    def launched_pids
      @launched_pids ||= []
    end

    def kill_launched_processes
      launched_pids.uniq!
      puts "no pid found " if launched_pids.empty?
      launched_pids.dup.each do |pid|
        begin
          Process.kill "-INT", pid
          Process.waitpid pid
          launched_pids.delete(pid)
        rescue Errno::ECHILD => e
          puts "[#{e.class}] #{e.message}\n  " << e.backtrace.join("\n  ")
        end
      end
    end

    def run(*args)
      unless system(*args)
        fail("command failed:\n#{args.inspect}\n#{$?.inspect}")
      end
    end

    def backups
      @backups ||= []
    end

    # % rabbitmq-plugins list
    # [e] amqp_client                       2.8.7
    # [ ] eldap                             2.8.7-gite309de4
    # [ ] erlando                           2.8.7
    # [e] mochiweb                          2.3.1-rmq2.8.7-gitd541e9a
    # [ ] rabbitmq_auth_backend_ldap        2.8.7
    # [ ] rabbitmq_auth_mechanism_ssl       2.8.7
    # [ ] rabbitmq_consistent_hash_exchange 2.8.7
    # [ ] rabbitmq_federation               2.8.7
    # [ ] rabbitmq_federation_management    2.8.7
    # [ ] rabbitmq_jsonrpc                  2.8.7
    # [ ] rabbitmq_jsonrpc_channel          2.8.7
    # [ ] rabbitmq_jsonrpc_channel_examples 2.8.7
    # [E] rabbitmq_management               2.8.7
    # [e] rabbitmq_management_agent         2.8.7
    # [E] rabbitmq_management_visualiser    2.8.7
    # [e] rabbitmq_mochiweb                 2.8.7
    # [ ] rabbitmq_shovel                   2.8.7
    # [ ] rabbitmq_shovel_management        2.8.7
    # [ ] rabbitmq_stomp                    2.8.7
    # [ ] rabbitmq_tracing                  2.8.7
    # [ ] rfc4627_jsonrpc                   2.8.7-gita5e7ad7
    # [e] webmachine                        1.9.1-rmq2.8.7-git52e62bc
    #
    # http://www.rabbitmq.com/man/rabbitmq-plugins.1.man.html

    def backup_plugins
      backups << `rabbitmq-plugins list`.scan(/^\[[E]\]\s*([^\s]+)\s*.+?\s*$/).flatten
    end

    def restore_plugins
      enable_plugins(*backups.pop)
    end

    def enable_plugins(*plugins)
      run("rabbitmq-plugins enable " << plugins.join(" "))
    end
  end


  attr_reader :pid, :port
  attr_accessor :base_dir, :nodename, :rabbitmq_server_path
  attr_accessor :max_attempts, :max_wait_limit, :wait_interval
  attr_accessor :keep_port

  def initialize(options = {})
    @pid = nil
    @port = nil
    (options || {}).each{|key, value| send("#{key}=", value) }
    # @base_dir ||= File.expand_path("../../../tmp/rabbitmq", __FILE__)
    @base_dir ||= Dir.mktmpdir
    FileUtils.mkdir_p(@base_dir)
    @rabbitmq_server_path = find_rabbitmq_server
    @keep_port = false
    @max_attempts = 10
    @max_wait_limit = 16
    @wait_interval = 0.5
  end

  def find_rabbitmq_server
    ENV["PATH"].split(/:/).find do |dir|
      Dir.glob("#{dir}/rabbitmq-server") do |path|
        return path if File.executable?(path)
      end
    end
  end

  def launch
    raise "Something wrong! launched process is still living." unless self.class.launched_pids.empty?
    ps_line = `ps aux`.split(/\n/).select{|line| line =~ /^#{ENV['USER']}\s+\d+\s+.+\-sname rspec/}
    raise "process is still remain\n#{ps_line}" unless ps_line.empty?
    raise "rabbitmq-server not found" unless @rabbitmq_server_path
    return self if try_launch
    raise "failed to invoke rabbitmq-server."
  end

  # see http://ja.wikipedia.org/wiki/ポート番号
  UNRESERVED_PORT_MIN = 1024

  def try_launch
    # puts "#{__FILE__}##{__LINE__}\n  " << caller.join("\n  ")

    unless @keep_port
      @port = rand(32768 - UNRESERVED_PORT_MIN) + UNRESERVED_PORT_MIN
    end

    envp = {
      "RABBITMQ_NODENAME"        => "rspec",
      "RABBITMQ_NODE_PORT"       => @port.to_s,
      "RABBITMQ_NODE_IP_ADDRESS" => "auto",
      "RABBITMQ_MNESIA_BASE"     => @base_dir.to_s,
      "RABBITMQ_LOG_BASE"        => @base_dir.to_s,
    }
    args = [envp, rabbitmq_server_path, {pgroup: true, chdir: @base_dir, in: :close}]
    Process.spawn(*args)

    x = Time.now
    limit = x + max_wait_limit

    while Time.now < limit do
      sleep wait_interval
      line = `ps aux`.split(/\n/).select{|line| line =~ /^#{ENV['USER']}\s+\d+\s+.+\-sname\ rspec.+tcp_listeners \[\{\"auto\",#{@port}\}\]/}.flatten.sort.first
      next unless line
      pid = line.scan(/^#{ENV['USER']}\s+(\d+)\s+/).flatten.first
      next unless pid
      @pid = pid.to_i
      self.class.launched_pids << @pid

      Process.waitpid2(@pid, Process::WNOHANG) # 起動されているはず
      Process.kill 0, @pid # プロセスの存在確認。プロセスが起動してたらスルー、いなかったら Errno::ESRCH がraiseされる。
      break
    end
    x = Time.now
    limit = x + max_wait_limit
    while Time.now < limit do
      sleep wait_interval

      # netstat -an は Linux / BSD ともに有効
      # どちらかに限ればもう少し効率的な探し方はある。たとえば Linux 限定でよければ netstat -lnt ...
      cmd = "netstat -an | fgrep LISTEN | fgrep #{@port}"
      y = `#{cmd}`
      return true if y.lines.to_a.size > 0
    end

    puts "launch timed out"
    return false
  rescue Errno::ECHILD, Errno::ESRCH => e
    puts "[#{e.class}] #{e.message}\n  " << e.backtrace.join("\n  ")
    false
  end
end
