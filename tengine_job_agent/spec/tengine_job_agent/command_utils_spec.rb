# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tmpdir'
require 'tempfile'

describe TengineJobAgent::CommandUtils do
  describe ".included" do
    it "ClassMethodsを追加" do
      foo = Class.new do
        include TengineJobAgent::CommandUtils
      end
      foo.singleton_class.ancestors.should include(TengineJobAgent::CommandUtils::ClassMethods)
    end
  end

  context "::ClassMethods" do
    describe "#load_config" do
      subject { Class.new { include TengineJobAgent::CommandUtils::ClassMethods }.new }

      it "Hashをかえす" do
        Dir.chdir File.expand_path("../..", __FILE__) do
          subject.load_config.should be_kind_of(Hash)
        end
      end

      it "./tengine_job_agent.ymlを読む" do
        Dir.mktmpdir do |nam|
          Dir.chdir nam do
            File.open("tengine_job_agent.yml", "wb") {|f| f.puts "foo: bar\n" }
            subject.load_config.should == { "foo" => "bar" }
          end
        end
      end

      it "./config/tengine_job_agent.ymlを読む" do
        Dir.mktmpdir do |nam|
          Dir.chdir nam do
            Dir.mkdir "config"
            File.open("config/tengine_job_agent.yml", "wb") {|f| f.puts "foo: bar\n" }
            subject.load_config.should == { "foo" => "bar" }
          end
        end
      end

      it "/etc/tengine_job_agent.ymlを読む" do
        begin
          if File.exist? "/etc/tengine_job_agent.yml"
            obj = YAML.load_file "/etc/tengine_job_agent.yml"
            subject.load_config.should == obj
          else
            File.open("/etc/tengine_job_agent.yml", "wb") {|f| f.puts "foo: bar\n" }
            subject.load_config.should == { "foo" => "bar" }
          end
        rescue Errno::EACCES
          pending $!.message
        end
      end
    end

    describe "#new_logger" do
      subject { Class.new { include TengineJobAgent::CommandUtils::ClassMethods }.new }
      before { subject.stub(:name).and_return("foobar") }

      it "logfileを指定する場合" do
        Dir.mktmpdir do |nam|
          Logger.should_receive(:new).with("foo/bar/baz.log")
          subject.new_logger('logfile' => "foo/bar/baz.log")
        end
      end

      it "logfileもlog_dirも指定する場合" do
        Dir.mktmpdir do |nam|
          Logger.should_receive(:new).with(/\/foobar-\d+?.log$/)
          subject.new_logger({})
        end
      end

      it "Loggerを返す" do
        Dir.mktmpdir do |nam|
          subject.new_logger('log_dir' => nam).should be_kind_of(Logger)
        end
      end

      it "引数はディレクトリである" do
        Tempfile.new("") do |f|
          subject.new_logger('log_dir' => "nonexistent").should raise_exception(Errno::ENOENT)
          subject.new_logger('log_dir' => f.path).should raise_exception(Errno::ENOENT)
        end
      end

      it "ログファイルは引数のディレクトリの中にできる" do
        Dir.mktmpdir do |nam|
          subject.new_logger('log_dir' => nam)
          nam.should have_at_least(3).files
        end
      end

    end

    describe "#process" do
      subject { Class.new { include TengineJobAgent::CommandUtils } }
      let(:instance) { mock(subject.new) }
      before do
        instance
        subject.stub(:new).with(anything, anything, anything).and_return(instance)
        subject.stub(:name).and_return(File.basename(__FILE__, ".rb"))
      end

      it "インスタンスを生成してprocessを呼ぶ" do
        instance.should_receive(:process)
        Dir.chdir File.expand_path("../..", __FILE__) do
          subject.process
        end
      end

      it "失敗するとfalseを返す" do
        instance.should_receive(:process).and_raise(RuntimeError)
        Dir.chdir File.expand_path("../..", __FILE__) do
          subject.process.should == false
        end
      end
    end
  end
end
