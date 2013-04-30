# -*- coding: utf-8 -*-
require 'spec_helper'

require 'net/ssh'

describe 'hadoop_job_run' do
  include NetSshMock

  before(:all) do
    Tengine.plugins.add(Tengine::Job::Dsl::Loader)
  end

  def load_dsl(filename)
    config = {
      :action => "load",
      :tengined => { :load_path => File.expand_path("../../../../../examples/#{filename}", __FILE__) },
    }
    @version = File.read(File.expand_path("../../../../../examples/VERSION", __FILE__)).strip
    @bootstrap = Tengine::Core::Bootstrap.new(config)
    @bootstrap.boot
    Tengine::Core::Setting.stub(:dsl_version).and_return(@version)
  end

  describe "基本的なジョブDSL" do
    context "0021_dynamic_env.rb" do
      before do
        Tengine::Job::Template::Jobnet.delete_all
        Tengine::Resource::PhysicalServer.delete_all
        TestServerFixture.test_server1
        TestCredentialFixture.test_credential1
        load_dsl("0021_dynamic_env.rb")
      end

      shared_examples_for "実行時に環境変数を設定できる" do
        it "j1" do
          mock_event = mock(:event)
          signal = Tengine::Job::Runtime::Signal.new(mock_event)
          mock_ssh = mock(:ssh)
          Net::SSH.should_receive(:start).and_yield(mock_ssh)
          mock_shell_for_script_executable(mock_ssh) do |ch|
            ch.should_receive(:send_data).with(/.+ export FOO=BAR .+; echo \".+?\"\n/).and_return do
              client = ch[:client]
              client.dispatch("123\n") # PID
              client.dispatch("#{client.one_time_token}\n")
            end
          end
          @root.element("j1").run(@execution)
        end

        it "j2" do
          mock_event = mock(:event)
          signal = Tengine::Job::Runtime::Signal.new(mock_event)
          mock_ssh = mock(:ssh)
          Net::SSH.should_receive(:start).and_yield(mock_ssh)
          mock_shell_for_script_executable(mock_ssh) do |ch|
            ch.should_receive(:send_data).with(/.+ export SERVER_NAME=test_server1 && export DNS_NAME=localhost .+; echo \".+?\"\n/).and_return do
              client = ch[:client]
              client.dispatch("123\n") # PID
              client.dispatch("#{client.one_time_token}\n")
            end
          end
          @root.element("j2").run(@execution)
        end
      end

      context "rjn0021_1" do
        before do
          @template = Tengine::Job::Template::RootJobnet.find_by_name!("rjn0021_1")

          @template.element("j1").class.should == Tengine::Job::Template::SshJob
          @template.element("j2").class.should == Tengine::Job::Template::SshJob

          mock_sender = mock(:sender)
          mock_sender.should_receive(:fire).with(any_args)
          @execution = @template.generate.execute(:sender => mock_sender)
          @root = @execution.root_jobnet
        end
        it_should_behave_like "実行時に環境変数を設定できる"
      end

      context "/rjn0021/rjn0021_1" do
        before do
          @template = Tengine::Job::Template::RootJobnet.find_by_name!("rjn0021")
          mock_sender = mock(:sender)
          mock_sender.should_receive(:fire).with(any_args)
          @execution = @template.generate.execute(:sender => mock_sender)
          @root = @execution.root_jobnet.vertex_by_name_path("/rjn0021/rjn0021_1")
        end
        it_should_behave_like "実行時に環境変数を設定できる"
      end

      context "/rjn0021/rjn0021_2" do
        before do
          @template = Tengine::Job::Template::RootJobnet.find_by_name!("rjn0021")
          mock_sender = mock(:sender)
          mock_sender.should_receive(:fire).with(any_args)
          @execution = @template.generate.execute(:sender => mock_sender)
          @root = @execution.root_jobnet.vertex_by_name_path("/rjn0021/rjn0021_2")
        end
        it_should_behave_like "実行時に環境変数を設定できる"
      end

    end

  end

end
