# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'
require 'tempfile'

describe 'connection error' do
  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../../../../../lib/tengine/job/runtime/drivers/job_control_driver.rb", File.dirname(__FILE__))
  driver :job_control_driver

  let :ssh_dir do
    File.expand_path("../../../../../sshd", __FILE__)
  end

  before :all do
    raise "WRONG" if $_pid

    uid = Etc.getlogin
    case uid
    when "root"
      pending "rootは危険なのでこのテストを実行できません"
    when NilClass
      raise "who am i?"
    end

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
    $_port = nil

    # 指定したポートはもう使われているかもしれないので、その際は
    # sshdが起動に失敗するので、何回かポートを変えて試す。
    catch(:return) do
      n = 0
      @port = rand(32768)
      begin
        Tempfile.open("sshd_config", ssh_dir) do |conf|
          File.open(template, "rb") do |tmpl|
            conf.write ERB.new(tmpl.read).result(binding)
          end
          conf.flush
          conf.close(false) # no unlink
          argv = [sshd, "-Def", conf.path, "-h", hostkey]
          $_pid = Process.spawn(*argv)
          x = Time.now
          while Time.now < x + 16.0 do # まあこんくらい待てばいいでしょ
            sleep 0.1
            Process.waitpid2($_pid, Process::WNOHANG)
            Process.kill 0, $_pid
            # netstat -an は Linux / BSD ともに有効
            # どちらかに限ればもう少し効率的な探し方はある。たとえば Linux 限定でよければ netstat -lnt ...
            y = `netstat -an | fgrep LISTEN | fgrep #{@port}`
            if y.lines.to_a.size > 1
              $_port = @port
              throw :return
            end
          end
          pending "failed to invoke sshd in 16 secs."
        end
      rescue Errno::ECHILD, Errno::ESRCH
        if (n += 1) > 10
          pending "10 attempts to invoke sshd failed."
        else
          @port = rand(32768)
          retry
        end
      end
    end
  end

  after :all do
    if $_pid
      begin
        Process.kill "INT", $_pid
        Process.waitpid $_pid
      rescue Errno::ECHILD
      end
    end
  end

  # in [rjn0001]
  # (S1) --e1-->(j11)--e2-->(j12)--e3-->(E1)
  #
  context "rjn0001" do
    before do
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0001SimpleJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @base_props = {
        :execution_id => @execution.id.to_s,
        :root_jobnet_id => @root.id.to_s,
        :target_jobnet_id => @root.id.to_s,
      }
      Tengine::Resource::Server.find_by_name("test_server1").update_attributes :properties => { :ssh_port => $_port }
    end

    after do
      # 中身を書き換えてしまうので他のテストに影響しないように削除します
      Tengine::Resource::Credential.delete_all
      Tengine::Resource::Server.delete_all
    end

    context "credential not found" do
      it "対象のジョブはerrorになりエラーイベントが発火される" do
        Tengine::Resource::Credential.delete_all
        @root.phase_key = :starting
        @ctx.edge(:e1).phase_key = :transmitting
        @ctx.vertex(:j11).phase_key = :ready
        @root.save!
        @root.reload
        tengine.should_fire(:"error.job.job.tengine", an_instance_of(Hash))
        tengine.receive("start.job.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :root_jobnet_name_path => @root.name_path,
            :target_jobnet_id => @root.id.to_s,
            :target_jobnet_name_path => @root.name_path,
            :target_job_id => @ctx.vertex(:j11).id.to_s,
            :target_job_name_path => @ctx.vertex(:j11).name_path,
          })
        @root.reload
        @ctx.edge(:e1).phase_key.should == :transmitted
        @ctx.edge(:e2).phase_key.should == :active
        @ctx.vertex(:j11).phase_key.should == :error
      end
    end


    context "wrong credential" do
      it "対象のジョブはerrorになりエラーイベントが発火される" do
        credential = Tengine::Resource::Credential.find_by_name("test_credential1")
        hash = credential.auth_values.dup
        hash['username'] = "piccolo"
        credential.auth_values = hash
        credential.save!
        @root.phase_key = :starting
        @ctx.edge(:e1).phase_key = :transmitting
        @ctx.vertex(:j11).phase_key = :ready
        @root.save!
        @root.reload
        tengine.should_fire(:"error.job.job.tengine", an_instance_of(Hash))
        tengine.receive("start.job.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :root_jobnet_name_path => @root.name_path,
            :target_jobnet_id => @root.id.to_s,
            :target_jobnet_name_path => @root.name_path,
            :target_job_id => @ctx.vertex(:j11).id.to_s,
            :target_job_name_path => @ctx.vertex(:j11).name_path,
          })
        @root.reload
        @ctx.edge(:e1).phase_key.should == :transmitted
        @ctx.edge(:e2).phase_key.should == :active
        @ctx.vertex(:j11).phase_key.should == :error
      end
    end

    context "server not found" do
      it "対象のジョブはerrorになりエラーイベントが発火される" do
        Tengine::Resource::Server.delete_all
        @root.phase_key = :starting
        @ctx.edge(:e1).phase_key = :transmitting
        @ctx.vertex(:j11).phase_key = :ready
        @root.save!
        @root.reload
        tengine.should_fire(:"error.job.job.tengine", an_instance_of(Hash))
        tengine.receive("start.job.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :root_jobnet_name_path => @root.name_path,
            :target_jobnet_id => @root.id.to_s,
            :target_jobnet_name_path => @root.name_path,
            :target_job_id => @ctx.vertex(:j11).id.to_s,
            :target_job_name_path => @ctx.vertex(:j11).name_path,
          })
        @root.reload
        @ctx.edge(:e1).phase_key.should == :transmitted
        @ctx.edge(:e2).phase_key.should == :active
        @ctx.vertex(:j11).phase_key.should == :error
      end
    end


    context "wrong server IP" do
      it "対象のジョブはerrorになりエラーイベントが発火される" do
        server = Tengine::Resource::Server.find_by_name("test_server1")
        server.addresses = {'private_ip_address' => "unexist_ip"}
        server.save!
        @root.phase_key = :starting
        @ctx.edge(:e1).phase_key = :transmitting
        @ctx.vertex(:j11).phase_key = :ready
        @root.save!
        @root.reload
        tengine.should_fire(:"error.job.job.tengine", an_instance_of(Hash))
        tengine.receive("start.job.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :root_jobnet_name_path => @root.name_path,
            :target_jobnet_id => @root.id.to_s,
            :target_jobnet_name_path => @root.name_path,
            :target_job_id => @ctx.vertex(:j11).id.to_s,
            :target_job_name_path => @ctx.vertex(:j11).name_path,
          })
        @root.reload
        @ctx.edge(:e1).phase_key.should == :transmitted
        @ctx.edge(:e2).phase_key.should == :active
        @ctx.vertex(:j11).phase_key.should == :error
      end
    end


  end

end


