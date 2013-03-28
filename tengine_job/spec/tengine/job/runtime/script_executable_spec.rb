# -*- coding: utf-8 -*-
require 'spec_helper'
require 'erb'
require 'etc'
require 'tempfile'

describe Tengine::Job::Runtime::SshJob do

  # tengine_job_agent_runを呼び出すのではなく、SSHでコマンドを実行するだけなので、
  # rabbitmq-serverは起動しません。

  before :all do
    begin
      @test_sshd = TestSshd.new.launch
      @pending_msg = nil
    rescue TestSshd::AbortError => e
      @pending_msg = e.message
    end
  end
  before do
    pending(@pending_msg) if @pending_msg
  end

  after :all do
    TestSshd.kill_launched_processes
  end

  before do
    Tengine::Resource::Server.delete_all
    Tengine::Resource::Credential.delete_all
    TestSshdResource.new(@test_sshd).tap do |r|
      @server = r.find_or_create_server
      @credential = r.find_or_create_credential
    end
  end

  describe :execute do

    it "終了コードを取得できる" do
      j = Tengine::Job::Runtime::SshJob.new(
        :server_name => @server.name,
        :credential_name => @credential.name,
        :script => File.expand_path("tengine_job_test.sh", @test_sshd.base_dir)
      )
      j.execute(j.script)
    end

#       it "終了コードを取得できる" do
#         Tengine::Job::ScriptActual.new(:name => "echo_foo",
#           :script => "/Users/goku/tengine/echo_foo.sh"
#           )
#       end

    it "https://www.pivotaltracker.com/story/show/22269461" do
      j = Tengine::Job::Runtime::SshJob.new(
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

  describe "#run" do
    before do
      # tengine_job_agent_run を使わないようにします
      ENV['MM_RUNNER_PATH'] = ""
    end

    after do
      ENV.delete('MM_RUNNER_PATH')
    end

    # https://www.pivotaltracker.com/story/show/43918327
    it "開発環境(mac, zsh)でジョブが実行されない" do
      dir = File.expand_path("../../../../..", __FILE__)
      text_path = File.expand_path("tmp/log/env.txt", dir)
      script_path = File.expand_path("spec/tengine/job/runtime/script_executable/echo_env.sh", dir)
      script = "cd #{dir} && #{script_path} #{text_path}"
      j = Tengine::Job::Runtime::SshJob.new(
        :server_name => @server.name,
        :credential_name => @credential.name,
        :script => script
      )
      # mock_execution = mock(:execution, {
      #                         id: "execution_id1",
      #                         signal: nil,
      #                         estimated_time: 10,
      #                         actual_estimated_end: nil,
      #                         preparation_command: nil,
      #                       })
      j.execute(j.script)
      60.times do # ファイルができるまで30秒間待ってみる
        break if File.exist?(text_path)
        sleep(0.5)
      end
      j.error_messages.should be_blank
      File.exist?(text_path).should == true
      # File.read(text_path).should == `env | sort` # PATHや実行時に環境変数が異なるのでこの比較はできません
      text = File.read(text_path)
      %w[USER HOME].each do |key|
        text.should =~ /^#{key}\=#{ENV[key]}$/
      end
    end
  end

  context "tengine_job_agent_run" do

    # Travis−CI上では gemfiles/Gemfile* によって、その他の場合にはgemとしてインストールされるので、
    # tengine_job_agent_run がインストールされているはずですが、SSHを経由してもPATH上にあるかどうか
    # をテストします。
    it "be found on PATH" do
      target = "tengine_job_agent_run"

      dir = File.expand_path("../../../../..", __FILE__)
      text_path = File.expand_path("tmp/log/env.txt", dir)
      script_path = File.expand_path("spec/tengine/job/runtime/script_executable/find_in_path", dir)
      script = "cd #{dir} && #{script_path} #{text_path}"
      j = Tengine::Job::Runtime::SshJob.new(
        :server_name => @server.name,
        :credential_name => @credential.name,
        :script => "#{script_path} #{target}"
      )
      found_path = nil
      j.execute(j.script) do |ch, data|
        found_path = data.strip
      end

      found_path.sub(/\<\$PATH: [^\<\>]+\>$/, '').strip.should =~ /#{target}$/
    end

  end

end
