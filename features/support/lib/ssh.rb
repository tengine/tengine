# -*- encoding: utf-8 -*-

require 'rubygems'
require 'net/ssh'

class SSH

  def initialize(host, user, sudo_password, opts)
    @host = host
    @user = user
    @sudo_password = sudo_password
    @opts = opts
  end

  def open
    puts "[open] host => #{@host}, user => #{@user}, sudo_password => #{@sudo_password}, opts => #{@opts} "
    Net::SSH.start(@host, @user, @opts) do |ssh|
      session = Session.new(ssh, @sudo_password)
      yield session
    end
  end

end

class Session

  def initialize(ssh, password)
    @ssh = ssh
    @password = password
  end

  def exec(command) 
    puts "[ssh:command] #{command}"
    data = @ssh.exec!(command)
    puts "[stdout] #{data}"
    data
  end

  def sudo(command) 
    command = "sudo -p 'sudo password: ' #{command}"
    puts "[command] #{command}"
    @ssh.open_channel do |ch|

      ch.request_pty do |ch, success|
        abort "could not obtain pty" unless success
      end

      ch.exec command do |ch, success|
        abort "could not execute sudo #{command}" unless success
        ch.on_data do |ch, data|
          puts "[stdout] #{data}"
          if data =~ /sudo password: /
            ch.send_data("#{@password}\n")
          end
        end
        ch.on_extended_data do |ch, type, data|
          puts "[stderr] #{data}"
        end
      end
    end
    @ssh.loop
  end

end
