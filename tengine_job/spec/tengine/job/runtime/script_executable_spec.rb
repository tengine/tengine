# -*- coding: utf-8 -*-
require 'spec_helper'
require 'erb'
require 'etc'
require 'tempfile'

describe Tengine::Job::Runtime::SshJob do
  before :all do
    @test_sshd = TestSshd.new.launch
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
      dir = File.expand_path("../../../..", __FILE__)
      text_path = "tmp/log/env.txt"
      script = "cd #{dir} && spec/tengine/job/script_executable/echo_env.sh #{text_path}"
      j = Tengine::Job::Runtime::SshJob.new(
        :server_name => @server.name,
        :credential_name => @credential.name,
        :script => script
      )
      mock_execution = mock(:execution, {
                              id: "execution_id1",
                              signal: nil,
                              estimated_time: 10,
                              actual_estimated_end: nil,
                              preparation_command: nil,
                            })
      j.run(mock_execution)
      100.times do # ファイルができるまで50秒間待ってみる
        break if File.exist?(text_path)
        sleep(0.5)
      end
      File.exist?(text_path).should == true
      # File.read(text_path).should == `env | sort` # PATHや実行時に環境変数が異なるのでこの比較はできません
      text = File.read(text_path)
      %w[USER HOME].each do |key|
        text.should =~ /^#{key}\=#{ENV[key]}$/
      end
    end
  end
end
