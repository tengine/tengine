# -*- coding: utf-8 -*-
require 'spec_helper'

require 'yaml'
require 'tengine/support/yaml_with_erb'
require 'rbconfig'

describe TengineJobAgent::Run do

  before do
    @log_buffer = StringIO.new
    @logger = Logger.new(@log_buffer)
    config = YAML.load_file(File.expand_path("../config/tengine_job_agent.yml.erb",
                                             File.dirname(__FILE__)))
    @config = config.inject({}) {|r, (k, v)| r.update k.intern => v }
  end

  subject do
    Dir.chdir File.expand_path("../..", __FILE__) do
      TengineJobAgent::Run.new(@logger, %w"scripts/echo_foo.sh", @config)
    end
  end

  it { should_not be_nil }

  describe "#process" do

    let(:f) { mock(File.open("/dev/null")) }

    before do
      subject.stub(:spawn_watchdog).and_return mock(Numeric.new)
      f
      File.stub(:open).with(an_instance_of(String), "r").and_yield(f)
      File.stub(:open).with(an_instance_of(String), "w")
    end

    context "正常起動" do
      it "EXIT_SUCCESS" do
        STDOUT.stub(:puts).with(an_instance_of(String))
        f.stub(:gets).and_return("0\n")
        subject.process.should == true
      end
    end

    context "spawnできない" do
      it "EXIT_FAILURE" do      
        STDERR.stub(:puts) do |arg|
          arg.should =~ /foo bar/
        end
        f.stub(:read).and_return("foo bar")
        f.stub(:gets).and_return("foo bar")
        f.stub(:rewind)
        subject.process.should == false
      end
    end

    context "timeout" do
      it "EXIT_FAILURE" do
        f.stub(:gets)
        lambda { subject.process }.should raise_exception(Timeout::Error)
      end
    end
  end

  describe "#spawn_watchdog" do
    it "tengine_job_agent_watchdogを起動する" do
      watchdog = File.expand_path("../../bin/tengine_job_agent_watchdog", File.dirname(__FILE__))
      Process.should_receive(:spawn).with(RbConfig.ruby, watchdog, an_instance_of(String), anything)
      subject.spawn_watchdog
    end

    it "pidを返す" do
      pid = mock(Numeric.new)
      Process.stub(:spawn).with(RbConfig.ruby, anything, anything, anything).and_return(pid)
      subject.spawn_watchdog.should == pid
    end

    it "終了を待たない" do
      Process.stub(:spawn).with(RbConfig.ruby, anything, anything, anything)
      Process.should_not_receive :wait
      Process.should_not_receive :waitpid
      Process.should_not_receive :waitpid2
      subject.spawn_watchdog
    end
  end

  describe "#initialize" do
    it "第一引数にlogger" do
      watchdog = File.expand_path("../../bin/tengine_job_agent_watchdog", File.dirname(__FILE__))
      Process.should_receive(:spawn).with(RbConfig.ruby, watchdog, an_instance_of(String), anything)
      subject.spawn_watchdog
      @log_buffer.string.should_not be_empty
    end

    it "第二引数は起動するプロセスへの引数の配列" do
      watchdog = File.expand_path("../../bin/tengine_job_agent_watchdog", File.dirname(__FILE__))
      Process.should_receive(:spawn).with(RbConfig.ruby, watchdog, an_instance_of(String), "scripts/echo_foo.sh")
      subject.spawn_watchdog
    end

    it "第三引数はconfig" do
      subject.stub(:timeout) do |tim|
        tim.should == @config[:timeout]
      end
    end
  end
end
