# -*- coding: utf-8 -*-
require 'erb'
require 'etc'
require 'tempfile'

class TestSshd

  class << self
    def launched_pids
      @launched_pids ||= []
    end

    def kill_launched_processes
      launched_pids.dup.each do |pid|
        begin
          Process.kill "INT", pid
          Process.waitpid pid
          launched_pids.delete(pid)
        rescue Errno::ECHILD
        end
      end
    end
  end

  attr_reader :pid, :port
  attr_accessor :base_dir, :template, :login, :sshd_path
  attr_accessor :max_attempts, :max_wait_limit, :wait_interval
  attr_accessor :template, :hostkey, :clientkey


  def initialize(options = {})
    @pid = nil
    @port = nil
    options.each{|key, value| send("#{key}=", value) }
    @base_dir ||= File.expand_path("../../sshd", __FILE__)
    @login ||= check_login
    @sshd_path ||= find_sshd
    @max_attempts = 10
    @max_wait_limit = 16
    @wait_interval = 0.1
  end

  def launch
    raise "Something wrong! launched process is still living." unless self.class.launched_pids.empty?
    raise "sshd not found" unless @sshd_path
    generate_sshd_config
    max_attempts.times do
      return self if try_launch
    end
    raise "#{max_attempts} attempts to invoke sshd failed."
  end

  private

  def check_login
    result = Etc.getlogin
    case result
    when "root"
      raise "Danger! root is too powerful to run this test."
    when NilClass
      raise "who am i?"
    end
    return result
  end

  def find_sshd
    ENV["PATH"].split(/:/).find do |dir|
      Dir.glob("#{dir}/sshd") do |path|
        return path if File.executable?(path)
      end
    end
    nil
  end

  def generate_sshd_config
    @template = File.expand_path("sshd_config.erb", base_dir)
    @hostkey = File.expand_path("ssh_host_rsa_key", base_dir)
    @clientkey = File.expand_path("id_rsa", base_dir)
    File.chmod(0400, @hostkey, @clientkey)
    File.chmod(0700, base_dir)
  end

  # see http://ja.wikipedia.org/wiki/ポート番号
  UNRESERVED_PORT_MIN = 1024

  def try_launch
    @port = rand(32768 - UNRESERVED_PORT_MIN) + UNRESERVED_PORT_MIN
    Tempfile.open("sshd_config", base_dir) do |conf|
      File.open(@template, "rb") do |tmpl|
        conf.write ERB.new(tmpl.read).result(binding)
      end
      conf.flush
      conf.close(false) # no unlink
      argv = [@sshd_path, "-Def", conf.path, "-h", hostkey]
      @pid = Process.spawn(*argv)
      self.class.launched_pids << @pid
      x = Time.now
      limit = x + max_wait_limit
      while Time.now < limit do
        sleep wait_interval
        Process.waitpid2(@pid, Process::WNOHANG)
        Process.kill 0, @pid # プロセスの存在確認。プロセスが起動してたらスルー、いなかったら Errno::ESRCH がraiseされる。
        # netstat -an は Linux / BSD ともに有効
        # どちらかに限ればもう少し効率的な探し方はある。たとえば Linux 限定でよければ netstat -lnt ...
        y = `netstat -an | fgrep LISTEN | fgrep #{@port}`
        return true if y.lines.to_a.size > 1
      end
      return false
    end
  rescue Errno::ECHILD, Errno::ESRCH
    false
  end

end
