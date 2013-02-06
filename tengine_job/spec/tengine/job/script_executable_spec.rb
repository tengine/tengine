# -*- coding: utf-8 -*-
require 'spec_helper'
require 'erb'
require 'etc'
require 'tempfile'

describe Tengine::Job::ScriptExecutable do
    let :ssh_dir do
      File.expand_path("../../../sshd", __FILE__)
    end

    before :all do
      # 1. sshdをさがす
      sshd = nil
      ENV["PATH"].split(/:/).find do |dir|
        Dir.glob("#{dir}/sshd") do |path|
          if File.executable?(path)
            sshd = path
            break
          end
        end
      end

      raise "sshd not found" unless sshd

      # 2. sshd_configの生成
      template = File.expand_path("sshd_config.erb", ssh_dir)
      hostkey = File.expand_path("ssh_host_rsa_key", ssh_dir)
      clientkey = File.expand_path("id_rsa", ssh_dir)
      File.chmod(0400, hostkey, clientkey)
      File.chmod(0700, ssh_dir)
      @port = nil

      # 指定したポートはもう使われているかもしれないので、その際は
      # sshdが起動に失敗するので、何回かポートを変えて試す。
      n = 0
      begin
        @port = rand(32768)
        Tempfile.open("sshd_config", ssh_dir) do |conf|
          File.open(template, "rb") do |tmpl|
            conf.write ERB.new(tmpl.read).result(binding)
          end
          conf.flush
          conf.close(false) # no unlink
          argv = [sshd, "-Def", conf.path, "-h", hostkey]
          @pid = Process.spawn(*argv)
          sleep 1 # まあこんくらい待てばいいでしょ
          Process.waitpid2(@pid, Process::WNOHANG)
        end
      rescue Errno::ECHILD
        raise "10 attempt to invoke sshd failed." if (n += 1) > 10
        retry
      end
    end

    after :all do
      if @pid
        begin
          Process.kill "INT", @pid
          Process.waitpid @pid
        rescue Errno::ECHILD
        end
      end
    end

    before do
      uid = Etc.getlogin
      case uid
      when "root"
        pending "rootは危険なのでこのテストを実行できません"
      when NilClass
        raise "who am i?"
      end
      @credential = Tengine::Resource::Credential.find_or_create_by_name!(
        :name => uid,
        :description => "myself",
        :auth_type_cd => :ssh_public_key,
        :auth_values => {
          :username => uid,
          :private_keys => [
             File.binread(Dir[File.expand_path("id_rsa", ssh_dir)].first),
          ],
          :passphrase => "",
        }
      )
      puts @port.inspect
      @server = Tengine::Resource::Server.find_or_create_by_name!(
        :name => "localhost",
        :description => "localhost",
        :provided_id => "localhost",
        :properties => {
          :ssh_port => @port,
        },
        :addressed => {
          :dns_name => "localhost",
          :ip_address => "localhost",
          :private_dns_name => "localhost",
          :private_ip_address => "localhost",
        },
      )
    end

  describe :execute do

    it "終了コードを取得できる" do
      j = Tengine::Job::JobnetActual.new(
        :server_name => @server.name, 
        :credential_name => @credential.name,
        :script => File.expand_path("tengine_job_test.sh", ssh_dir)
      )
      j.execute(j.script)
    end

#       it "終了コードを取得できる" do
#         Tengine::Job::ScriptActual.new(:name => "echo_foo",
#           :script => "/Users/goku/tengine/echo_foo.sh"
#           )
#       end

    it "https://www.pivotaltracker.com/story/show/22269461" do
      j = Tengine::Job::JobnetActual.new(
        :server_name => @server.name, 
        :credential_name => @credential.name,
        :script => "echo \u{65e5}\u{672c}\u{8a9e}"
      )
      str = ''
      j.execute(j.script) do |ch, data|
        str << data
      end
      str.force_encoding('UTF-8').should be_valid_encoding
    end
  end
end
