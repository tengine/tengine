# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

require 'net/ssh'

describe 'job_control_driver' do
  include Tengine::RSpec::Extension
  include NetSshMock

  target_dsl File.expand_path("../../../../lib/tengine/job/runtime/drivers/job_control_driver.rb", File.dirname(__FILE__))
  driver :job_control_driver

  context "rjn0001" do
    before do
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0001SimpleJobnetBuilder.new
      @jobnet = builder.create_actual
      @jobnet.children.each do |c|
        next unless c.is_a?(Tengine::Job::Runtime::SshJob)
        c.server_name = builder.test_server1.name
        c.credential_name = builder.test_credential1.name
        c.save!
      end
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @jobnet.id,
        })
    end

    context "ジョブの起動イベントを受け取ったら" do
      it "通常の場合" do
        pending "MM互換の環境変数をどうするか"
        @jobnet.phase_key = :starting
        @ctx.edge(:e1).phase_key = :transmitting
        @ctx.vertex(:j11).update_phase! :ready
        @jobnet.save!
        @jobnet.reload
        tengine.should_not_fire
        mock_ssh = mock(:ssh)
        Net::SSH.should_receive(:start).
          with("localhost", an_instance_of(Tengine::Resource::Credential), an_instance_of(Hash)).and_yield(mock_ssh)
        mock_channel = mock_channel_fof_script_executable(mock_ssh)
        mock_channel.should_receive(:exec) do |*args|
          args.length.should == 1
          # args.first.should =~ %r<export MM_ACTUAL_JOB_ID=[0-9a-f]{24} MM_ACTUAL_JOB_ANCESTOR_IDS=\\"[0-9a-f]{24}\\" MM_FULL_ACTUAL_JOB_ANCESTOR_IDS=\\"[0-9a-f]{24}\\" MM_ACTUAL_JOB_NAME_PATH=\\"/rjn0001/j11\\" MM_ACTUAL_JOB_SECURITY_TOKEN= MM_SCHEDULE_ID=[0-9a-f]{24} MM_SCHEDULE_ESTIMATED_TIME= MM_TEMPLATE_JOB_ID=[0-9a-f]{24} MM_TEMPLATE_JOB_ANCESTOR_IDS=\\"[0-9a-f]{24}\\" && tengine_job_agent_run -- \$HOME/j11\.sh>
          # TODO 要検討
          args.first.should =~ %r<MM_ACTUAL_JOB_ID=[0-9a-f]{24} MM_ACTUAL_JOB_ANCESTOR_IDS=\"[0-9a-f]{24}\" MM_FULL_ACTUAL_JOB_ANCESTOR_IDS=\"[0-9a-f]{24}\" MM_ACTUAL_JOB_NAME_PATH=\"/rjn0001/j11\" MM_ACTUAL_JOB_SECURITY_TOKEN= MM_SCHEDULE_ID=[0-9a-f]{24} MM_SCHEDULE_ESTIMATED_TIME= MM_TEMPLATE_JOB_ID=[0-9a-f]{24} MM_TEMPLATE_JOB_ANCESTOR_IDS=\"[0-9a-f]{24}\">
          args.first.should =~ %r<job_test j11>
        end
        tengine.receive("start.job.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @jobnet.id.to_s,
            :root_jobnet_name_path => @jobnet.name_path,
            :target_jobnet_id => @jobnet.id.to_s,
            :target_jobnet_name_path => @jobnet.name_path,
            :target_job_id => @ctx.vertex(:j11).id.to_s,
            :target_job_name_path => @ctx.vertex(:j11).name_path,
          })
        @jobnet.reload
        @ctx.edge(:e1).phase_key.should == :transmitted
        @ctx.edge(:e2).phase_key.should == :active
        @ctx.vertex(:j11).phase_key.should == :starting
      end

      context "starting直前stopによってinitializedになっている場合" do
        [:starting, :running].each do |root_phase_key|

          it "ルートが#{root_phase_key}" do
            @jobnet.phase_key = root_phase_key
            @ctx[:e1].phase_key = :closing
            @ctx[:e2].phase_key = :closing
            @ctx[:e3].phase_key = :closing
            @jobnet.save!

            @ctx[:j11].update_phase! :initialized

            @jobnet.reload
            tengine.should_fire(:"error.jobnet.job.tengine", {
                :source_name => @ctx[:root].name_as_resource,
                :properties=>{
                  :execution_id => @execution.id.to_s,
                  :root_jobnet_id => @jobnet.id.to_s,
                  :root_jobnet_name_path => @jobnet.name_path,
                  :target_jobnet_id => @jobnet.id.to_s,
                  :target_jobnet_name_path => @jobnet.name_path,
                }
              })
            tengine.receive("start.job.job.tengine", :properties => {
                :execution_id => @execution.id.to_s,
                :root_jobnet_id => @jobnet.id.to_s,
                :root_jobnet_name_path => @jobnet.name_path,
                :target_jobnet_id => @jobnet.id.to_s,
                :target_jobnet_name_path => @jobnet.name_path,
                :target_job_id => @ctx.vertex(:j11).id.to_s,
                :target_job_name_path => @ctx.vertex(:j11).name_path,
              })
            @jobnet.reload
            @ctx.edge(:e1).phase_key.should == :closing
            @ctx.edge(:e2).phase_key.should == :closed
            @ctx.edge(:e3).phase_key.should == :closed
            @ctx.vertex(:j11).phase_key.should == :initialized
            @jobnet.phase_key.should == :error
          end
        end

      end

      it "存在しないスクリプトを実行しようとした場合、標準エラー出力にエラーメッセージが返されるので、それを保持する" do
        @jobnet.phase_key = :starting
        @ctx.edge(:e1).phase_key = :transmitting
        @ctx.vertex(:j11).update_phase! :ready
        @jobnet.save!
        @jobnet.reload
        mock_ssh = mock(:ssh)
        Net::SSH.stub(:start).with(any_args).and_yield(mock_ssh)
        mock_channel = mock_channel_fof_script_executable(mock_ssh)
        mock_channel.stub(:exec).with(any_args).and_yield(mock_channel, true)
        mock_channel.stub(:on_data)
        mock_channel.should_receive(:on_extended_data).and_yield(mock_channel,
          "session", "[Errno::ENOENT] No such file or directory - /home/goku/unexist_script.sh")
        mock_channel.stub(:on_close)
        tengine.should_fire(:"error.job.job.tengine", {
            :source_name => @ctx[:j11].name_as_resource,
            :properties=>{
              :execution_id => @execution.id.to_s,
              :root_jobnet_id => @jobnet.id.to_s,
              :root_jobnet_name_path => @jobnet.name_path,
              :target_jobnet_id => @jobnet.id.to_s,
              :target_jobnet_name_path => @jobnet.name_path,
              :target_job_id => @ctx.vertex(:j11).id.to_s,
              :target_job_name_path => @ctx.vertex(:j11).name_path,
              :exit_status=>nil,
              :message=>"Failure to execute /rjn0001/j11 via SSH: [Errno::ENOENT] No such file or directory - /home/goku/unexist_script.sh"
            }
          })
        tengine.receive("start.job.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @jobnet.id.to_s,
            :root_jobnet_name_path => @jobnet.name_path,
            :target_jobnet_id => @jobnet.id.to_s,
            :target_jobnet_name_path => @jobnet.name_path,
            :target_job_id => @ctx.vertex(:j11).id.to_s,
            :target_job_name_path => @ctx.vertex(:j11).name_path,
          })
        @jobnet.reload
        @ctx.edge(:e1).phase_key.should == :transmitted
        @ctx.edge(:e2).phase_key.should == :active
        @ctx.vertex(:j11).tap do |job|
          job.phase_key.should == :error
          job.error_messages.should == [
            "[Errno::ENOENT] No such file or directory - /home/goku/unexist_script.sh",
            "Failure to execute /rjn0001/j11 via SSH: [Errno::ENOENT] No such file or directory - /home/goku/unexist_script.sh"
          ]
        end
        @jobnet.phase_key.should == :running
      end

    end


    it "PIDを取得できたら" do
      @ctx.edge(:e1).phase_key = :transmitted
      @ctx.edge(:e2).phase_key = :active
      @ctx.vertex(:j11).update_phase! :starting
      @jobnet.save!
      @jobnet.reload
      tengine.should_not_fire
      mock_event = mock(:event)
      @pid = "123"
      signal = Tengine::Job::Runtime::Signal.new(mock_event)
      signal.data = {:executing_pid => @pid}
      @ctx.vertex(:j11).ack(signal) # このメソッド内ではsaveされないので、ここでreloadもしません。
      @ctx.vertex(:j11).executing_pid.should == @pid
      @ctx.edge(:e1).phase_key.should == :transmitted
      @ctx.edge(:e2).phase_key.should == :active
      @ctx.vertex(:j11).phase_key.should == :running
    end

    test_error_message1 = "Job process failed. STDOUT and STDERR were redirected to files. You can see them at /home/goku/stdout-1234.log and /home/goku/stderr-1234.log on the server test_server1"
    {
      :success => ["0", {}],
      :error => ["1", {
          :stdout_log => "/home/goku/stdout-1234.log",
          :stderr_log => "/home/goku/stderr-1234.log",
          :message => test_error_message1
        }]
    }.each do |phase_key, (exit_status, extra_props)|
      it "ジョブ実行#{phase_key}の通知" do
        test_key = "test_key.finished.process.job.tengine"
        Tengine::Core::Event.delete_all(:conditions => {:key => test_key})
        Tengine::Core::Event.create!(:event_type_name => "job.heartbeat.tengine", :key => test_key)
        @jobnet.reload
        j11 = @jobnet.find_descendant_by_name_path("/rjn0001/j11")
        j11.executing_pid = "123"
        j11.update_phase! :running
        j11.previous_edges.length.should == 1
        j11.previous_edges.first.phase_key = :transmitted
        @ctx[:root].save!
        tengine.should_fire(:"#{phase_key}.job.job.tengine",
          :source_name => @ctx[:j11].name_as_resource,
          :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @jobnet.id.to_s,
            :root_jobnet_name_path => @jobnet.name_path,
            :target_jobnet_id => @jobnet.id.to_s,
            :target_jobnet_name_path => @jobnet.name_path,
            :target_job_id => @ctx[:j11].id.to_s,
            :target_job_name_path => @ctx[:j11].name_path,
            :exit_status => exit_status
          })
        tengine.receive(:"finished.process.job.tengine",
          :key => test_key,
          :source_name => @ctx[:j11].name_as_resource,
          :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @jobnet.id.to_s,
            :root_jobnet_name_path => @jobnet.name_path,
            :target_jobnet_id => @jobnet.id.to_s,
            :target_jobnet_name_path => @jobnet.name_path,
            :target_job_id => @ctx[:j11].id.to_s,
            :target_job_name_path => @ctx[:j11].name_path,
            :exit_status => exit_status
          }.merge(extra_props))
        @jobnet.reload
        @ctx.edge(:e1).phase_key.should == :transmitted
        @ctx.edge(:e2).phase_key.should == :active
        @ctx.vertex(:j11).tap do |j|
          j.phase_key.should == phase_key
          j.exit_status.should == exit_status
          if phase_key == :error
            j.error_messages.should == [test_error_message1]
          end
        end
      end
    end

    it "stuckからのfinished.process.job.tengine" do
      @jobnet.reload
      j11 = @jobnet.find_descendant_by_name_path("/rjn0001/j11")
      j11.update_phase! :stuck
      j11.previous_edges.first.phase_key = :transmitted
      @ctx[:root].save!
      tengine.receive(:"finished.process.job.tengine",
         :properties => {
           :execution_id => @execution.id.to_s,
           :root_jobnet_id => @jobnet.id.to_s,
           :root_jobnet_name_path => @jobnet.name_path,
           :target_jobnet_id => @jobnet.id.to_s,
           :target_jobnet_name_path => @jobnet.name_path,
           :target_job_id => @ctx[:j11].id.to_s,
           :target_job_name_path => @ctx[:j11].name_path,
           :exit_status => 0
         })
      @jobnet.reload
      @ctx.vertex(:j11).phase_key.should == :stuck
    end

    it "強制停止" do
      @pid = "123"
      @jobnet.reload
      j11 = @jobnet.find_descendant_by_name_path("/rjn0001/j11")
      j11.executing_pid = @pid
      j11.update_phase! :running
      j11.previous_edges.length.should == 1
      j11.previous_edges.first.phase_key = :transmitted
      @ctx[:root].save!

      tengine.should_not_fire
      mock_ssh = mock(:ssh)
      Net::SSH.should_receive(:start).
        with("localhost", an_instance_of(Tengine::Resource::Credential), an_instance_of(Hash)).and_yield(mock_ssh)
      mock_channel = mock_channel_fof_script_executable(mock_ssh)
      mock_channel.should_receive(:exec) do |*args|
        interval = Tengine::Job::Template::SshJob::Settings::DEFAULT_KILLING_SIGNAL_INTERVAL
        args.length.should == 1
        args.first.should =~ %r<tengine_job_agent_kill #{@pid} #{interval} KILL$>
      end
      tengine.receive(:"stop.job.job.tengine",
        :source_name => @ctx[:j11].name_as_resource,
        :properties => {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @jobnet.id.to_s,
          :target_jobnet_id => @jobnet.id.to_s,
          :target_job_id => @ctx[:j11].id.to_s,
        })
      @jobnet.reload
      @ctx.edge(:e1).phase_key.should == :transmitted
      @ctx.edge(:e2).phase_key.should == :active
      @ctx.vertex(:j11).tap do |j|
        j.phase_key.should == :dying
        j.exit_status.should == nil
      end
    end

    it "強制停止(ジョブネット)" do
      @pid11 = "11"
      @pid12 = "12"
      @jobnet.reload
      j11 = @jobnet.find_descendant_by_name_path("/rjn0001/j11")
      j11.executing_pid = @pid11
      j11.update_phase! :success
      j11.previous_edges.length.should == 1
      j11.previous_edges.first.phase_key = :transmitted
      j12 = @jobnet.find_descendant_by_name_path("/rjn0001/j12")
      j12.executing_pid = @pid12
      j12.update_phase! :running
      j12.previous_edges.length.should == 1
      j12.previous_edges.first.phase_key = :transmitted
      @ctx[:root].save!

      # phase_key が success の j11 は fireされない
      tengine.should_not_fire(:"stop.job.job.tengine")
      # phase_key が running の j12 は fireされる
      tengine.should_fire(:"stop.job.job.tengine",
        :source_name => @ctx[:j12].name_as_resource,
        :properties => {
          :stop_reason => "user_stop",
          :target_jobnet_id => @jobnet.id.to_s,
          :target_jobnet_name_path => "/rjn0001",
          :target_job_id => @ctx[:j12].id.to_s,
          :target_job_name_path => "/rjn0001/j12",
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @jobnet.id.to_s,
          :root_jobnet_name_path => "/rjn0001",
        })
      # jobnet に対して強制停止された
      tengine.receive(:"stop.jobnet.job.tengine",
        :source_name => @jobnet.name_as_resource,
        :properties => {
          :stop_reason => "user_stop",
          :target_jobnet_id => @jobnet.id.to_s,
          :target_jobnet_name_path => "/rjn0001",
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @jobnet.id.to_s,
          :root_jobnet_name_path => "/rjn0001",
        })
    end

    it "強制停止(後続のジョブ)" do
      @pid11 = "11"
      @pid12 = "12"
      @jobnet.reload
      j11 = @jobnet.find_descendant_by_name_path("/rjn0001/j11")
      j11.executing_pid = @pid11
      j11.update_phase! :success
      j11.previous_edges.length.should == 1
      j11.previous_edges.first.phase_key = :transmitted
      j12 = @jobnet.find_descendant_by_name_path("/rjn0001/j12")
      j12.executing_pid = @pid12
      j12.update_phase! :running
      j12.previous_edges.length.should == 1
      j12.previous_edges.first.phase_key = :transmitted
      @ctx[:root].save!

      mock_ssh = mock(:ssh)
      Net::SSH.should_receive(:start).
        with("localhost", an_instance_of(Tengine::Resource::Credential), an_instance_of(Hash)).and_yield(mock_ssh)
      mock_channel = mock_channel_fof_script_executable(mock_ssh)
      mock_channel.should_receive(:exec) do |*args|
        interval = Tengine::Job::Template::SshJob::Settings::DEFAULT_KILLING_SIGNAL_INTERVAL
        args.length.should == 1
        args.first.should =~ %r<tengine_job_agent_kill #{@pid12} #{interval} KILL$>
      end

      # job12 に対して強制停止
      tengine.receive(:"stop.job.job.tengine",
        :source_name => @ctx[:j12].name_as_resource,
        :properties => {
          :stop_reason => "user_stop",
          :target_jobnet_id => @jobnet.id.to_s,
          :target_jobnet_name_path => "/rjn0001",
          :target_job_id => @ctx[:j12].id.to_s,
          :target_job_name_path => "/rjn0001/j12",
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @jobnet.id.to_s,
          :root_jobnet_name_path => "/rjn0001",
        })
      @jobnet.reload
      @ctx.edge(:e1).phase_key.should == :transmitted
      @ctx.edge(:e2).phase_key.should == :transmitted
      @ctx.edge(:e3).phase_key.should == :active
      @ctx.vertex(:j11).tap do |j|
        j.phase_key.should == :success
        j.stop_reason.should == nil
      end
      @ctx.vertex(:j12).tap do |j|
        j.phase_key.should == :dying
        j.stop_reason.should == "user_stop"
      end
    end


    if ENV['PASSWORD']
    context "実際にSSHで接続", :ssh_actual => true do
      before do
        resource_fixture = GokuAtEc2ApNortheast.new
        credential = resource_fixture.goku_ssh_pw
        credential.auth_values = {:username => ENV['USER'], :password => ENV['PASSWORD']}
        credential.save!
        server = resource_fixture.hadoop_master_node
        server.local_ipv4 = "127.0.0.1"
        server.save!
      end

      it do
        tengine.should_not_fire
        tengine.receive("start.job.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @jobnet.id.to_s,
            :target_jobnet_id => @jobnet.id.to_s,
          })
        @jobnet.reload
        j11 = @jobnet.find_descendant_by_name_path("/rjn0001/j11")
        j11.executing_pid.should_not be_nil
        j11.exit_status.should == nil
        j11.phase_key.should == :running
        j11.previous_edges.length.should == 1
        j11.previous_edges.first.phase_key.should == :transmitted
      end

    end
    end
  end

  context "再実行" do
    context "ジョブを再実行" do
      {
        false => "後続も実行",
        true => "スポット再実行"
      }.each do |spot, caption|
        context(caption) do

          before do
            Tengine::Job::Runtime::Vertex.delete_all
            builder = Rjn0001SimpleJobnetBuilder.new
            @root = builder.create_actual
            @ctx = builder.context
            @execution = Tengine::Job::Runtime::Execution.create!({
                :root_jobnet_id => @root.id,
                :spot => spot, :retry => true,
                :target_actual_ids => [@ctx[:j11].id.to_s]
              })
            @ctx[:j11].update_phase! :success
            @ctx[:j12].update_phase! :error

            @root.phase_key = :running
            @ctx[:e1].phase_key = :transmitted
            @ctx[:e2].phase_key = :transmitted
            @ctx[:e3].phase_key = :active
            @root.save!
          end

          [:initialized, :success, :error, :stuck].each do |phase_key|
            it "phase_keyが#{phase_key}ならば再実行できるので、startのイベントを発火する" do
              @ctx[:j11].update_phase! phase_key
              tengine.should_fire(:"start.job.job.tengine", {
                  :source_name => @ctx[:j11].name_as_resource,
                  :properties=>{
                    :execution_id => @execution.id.to_s,
                    :root_jobnet_name_path => @root.name_path,
                    :root_jobnet_id => @root.id.to_s,
                    :target_jobnet_name_path => @root.name_path,
                    :target_jobnet_id => @root.id.to_s,
                    :target_job_name_path => @ctx.vertex(:j11).name_path,
                    :target_job_id => @ctx.vertex(:j11).id.to_s,
                  }
                })
              tengine.receive("restart.job.job.tengine", :properties => {
                  :execution_id => @execution.id.to_s,
                  :root_jobnet_id => @root.id.to_s,
                  :root_jobnet_name_path => @root.name_path,
                  :target_jobnet_id => @root.id.to_s,
                  :target_jobnet_name_path => @root.name_path,
                  :target_job_id => @ctx.vertex(:j11).id.to_s,
                  :target_job_name_path => @ctx.vertex(:j11).name_path,
                })
              @root.reload
              @root.phase_key.should == :running
              @ctx.edge(:e1).phase_key.should == :transmitted
              @ctx.vertex(:j11).phase_key.should == :ready
              if spot
                @ctx.vertex(:j12).phase_key.should == :error
                @ctx.edge(:e2).phase_key.should == :transmitted
                @ctx.edge(:e3).phase_key.should == :active
              else
                @ctx.vertex(:j12).phase_key.should == :initialized
                @ctx.edge(:e2).phase_key.should == :active
                @ctx.edge(:e3).phase_key.should == :active
              end
            end
          end

          [:ready, :starting, :running, :dying].each do |phase_key|
            it "phase_keyが#{phase_key}ならば再実行できず、エラーのイベントを発火する" do
              @ctx[:j11].update_phase! phase_key
              @root.save!
              tengine.should_fire("restart.job.job.tengine.error.tengined").with(any_args)
              Tengine::Core::Kernel.temp_exception_reporter(:except_test) do
                tengine.receive("restart.job.job.tengine", :properties => {
                    :execution_id => @execution.id.to_s,
                    :root_jobnet_id => @root.id.to_s,
                    :target_jobnet_id => @root.id.to_s,
                    :target_job_id => @ctx.vertex(:j11).id.to_s,
                  })
              end
              # 再実行に失敗したのでルートジョブネット以下何も状態は変更されません
              @root.reload
              @root.phase_key.should == :running
              @ctx.edge(:e1).phase_key.should == :transmitted
              @ctx.vertex(:j11).phase_key.should == phase_key
            end

          end
        end
      end

    end

  end


  context "<BUG>同じジョブネットが複数バージョン存在する際、ジョブ実行時にスクリプトに渡される環境変数の「MM_TEMPLATE_JOB_ID」「MM_TEMPLATE_JOB_ANCESTOR_IDS」が実行しているバージョン以外のものがセットされている" do
    shared_examples_for "最新のバージョンのルートジョブネットを参照する" do |dsl_version|

      it do
        @root.phase_key = :starting
        @root.element("prev!j11").phase_key = :transmitting
        @root.element('j11').update_phase! :ready
        @root.save!
        @root.reload
        tengine.should_not_fire
        mock_ssh = mock(:ssh)
        Net::SSH.should_receive(:start).
          with("localhost", an_instance_of(Tengine::Resource::Credential), an_instance_of(Hash)).and_yield(mock_ssh)
        mock_channel = mock_channel_fof_script_executable(mock_ssh)
        mock_channel.should_receive(:exec) do |*args|
          args.length.should == 1
          # args.first.should =~ %r<export MM_ACTUAL_JOB_ID=[0-9a-f]{24} MM_ACTUAL_JOB_ANCESTOR_IDS=\\"[0-9a-f]{24}\\" MM_FULL_ACTUAL_JOB_ANCESTOR_IDS=\\"[0-9a-f]{24}\\" MM_ACTUAL_JOB_NAME_PATH=\\"/rjn0001/j11\\" MM_ACTUAL_JOB_SECURITY_TOKEN= MM_SCHEDULE_ID=[0-9a-f]{24} MM_SCHEDULE_ESTIMATED_TIME= MM_TEMPLATE_JOB_ID=[0-9a-f]{24} MM_TEMPLATE_JOB_ANCESTOR_IDS=\\"[0-9a-f]{24}\\" && tengine_job_agent_run -- \$HOME/j11\.sh>
          args.first.should =~ %r<MM_ACTUAL_JOB_ID=[0-9a-f]{24} MM_ACTUAL_JOB_ANCESTOR_IDS=\"[0-9a-f]{24}\" MM_FULL_ACTUAL_JOB_ANCESTOR_IDS=\"[0-9a-f]{24}\" MM_ACTUAL_JOB_NAME_PATH=\"/rjn0001/j11\" MM_ACTUAL_JOB_SECURITY_TOKEN= MM_SCHEDULE_ID=[0-9a-f]{24} MM_SCHEDULE_ESTIMATED_TIME= MM_TEMPLATE_JOB_ID=[0-9a-f]{24} MM_TEMPLATE_JOB_ANCESTOR_IDS=\"[0-9a-f]{24}\">
          @template.dsl_version.should == dsl_version
          template_job = @template.element("/rjn0001/j11")
          args.first.should =~ %r<MM_TEMPLATE_JOB_ID=#{template_job.id.to_s}>
          args.first.should =~ %r<MM_TEMPLATE_JOB_ANCESTOR_IDS=\"#{@template.id.to_s}\">
          args.first.should =~ %r<job_test j11>
        end
        tengine.receive("start.job.job.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :root_jobnet_name_path => @root.name_path,
            :target_jobnet_id => @root.id.to_s,
            :target_jobnet_name_path => @root.name_path,
            :target_job_id => @root.element('j11').id.to_s,
            :target_job_name_path => @root.element('j11').name_path,
          })
        @root.reload
        @root.element('prev!j11').phase_key.should == :transmitted
        @root.element('next!j11').phase_key.should == :active
        @root.element('j11').phase_key.should == :starting
      end
    end

    context "バージョン1つだけ" do
      before do
        Tengine::Core::Setting.delete_all
        Tengine::Core::Setting.create!(:name => "dsl_version", :value => "1")
        Tengine::Job::Template::Vertex.delete_all
        Rjn0001SimpleJobnetBuilder.new.tap do |builder|
          @template = builder.create_template(:dsl_version => "1")
          @root = @template.generate
          @ctx = builder.context
        end
        @execution = Tengine::Job::Runtime::Execution.create!({
            :root_jobnet_id => @root.id,
          })
      end
      it{ @root.template.dsl_version.should == "1" }
      it_should_behave_like "最新のバージョンのルートジョブネットを参照する", "1"
    end

    context "バージョン2つ" do
      before do
        Tengine::Core::Setting.delete_all
        Tengine::Core::Setting.create!(:name => "dsl_version", :value => "2")
        Tengine::Job::Template::Vertex.delete_all
        Rjn0001SimpleJobnetBuilder.new.tap do |builder|
          builder.create_template(:dsl_version => "1")
          @template = builder.create_template(:dsl_version => "2")
          @root = @template.generate
          @ctx = builder.context
        end
        @execution = Tengine::Job::Runtime::Execution.create!({
            :root_jobnet_id => @root.id,
          })
      end
      it{ @root.template.dsl_version.should == "2" }
      it_should_behave_like "最新のバージョンのルートジョブネットを参照する", "2"
    end

    context "バージョン10個" do
      before do
        Tengine::Core::Setting.delete_all
        Tengine::Core::Setting.create!(:name => "dsl_version", :value => "10")
        Tengine::Job::Template::Vertex.delete_all
        Rjn0001SimpleJobnetBuilder.new.tap do |builder|
          (1..9).each do |idx|
            builder.create_template(:dsl_version => idx.to_s)
          end
          @template = builder.create_template(:dsl_version => "10")
          @root = @template.generate
          @ctx = builder.context
        end
        @execution = Tengine::Job::Runtime::Execution.create!({
            :root_jobnet_id => @root.id,
          })
      end
      it{ @root.template.dsl_version.should == "10" }
      it_should_behave_like "最新のバージョンのルートジョブネットを参照する", "10"
    end
  end

  context "https://www.pivotaltracker.com/story/show/22624209" do
    it "stuckにする" do
      Tengine::Core::Schedule.delete_all
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0001SimpleJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @root.phase_key = :initialized
      @root.save!
      EM.run_block do
        tengine.receive("expired.job.heartbeat.tengine", :properties => {
            :execution_id => @execution.id.to_s,
            :root_jobnet_id => @root.id.to_s,
            :target_job_id => @root.children[1].id.to_s,
          })
      end
      @root.reload
      @root.children[1].phase_key.should == :stuck
      @root.phase_key.should_not == :stuck # initialized
    end
  end

  context "start.job.job.tengine.failed.tengined" do
    it "stuckにする" do
      Tengine::Core::Schedule.delete_all
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0001SimpleJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @root.phase_key = :initialized
      @root.save!
      EM.run_block do
        tengine.receive("start.job.job.tengine.failed.tengined", :properties => {
          :original_event => {
            :event_type_name => "start.job.job.tengine",
            :properties => {
              :execution_id => @execution.id.to_s,
              :root_jobnet_id => @root.id.to_s,
              :root_jobnet_name_path => @root.name_path,
              :target_jobnet_id => @root.id.to_s,
              :target_jobnet_name_path => @root.name_path,
              :target_job_id => @root.children[1].id.to_s,
            }}})
      end
      @root.reload
      @root.children[1].phase_key.should == :stuck
      @root.phase_key.should_not == :stuck # initialized
    end

    it "broken event" do
      Tengine::Core::Schedule.delete_all
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0001SimpleJobnetBuilder.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @root.phase_key = :initialized
      @root.save!
      EM.run_block do
        tengine.receive("start.job.job.tengine.failed.tengined", :properties => {
          :original_event => {
            :event_type_name => "start.job.job.tengine",
            :properties => {
              :execution_id => @execution.id.to_s,
              :root_jobnet_id => @root.id.to_s,
              :root_jobnet_name_path => @root.name_path,
              :target_jobnet_id => @root.id.to_s,
              :target_jobnet_name_path => @root.name_path,
            }}})
      end
      @root.reload
      @root.children[1].phase_key.should == :initialized
      @root.phase_key.should_not == :stuck # initialized
    end
  end

  %w[
     stop.job.job.tengine.failed.tengined
     finished.process.job.tengine.failed.tengined
     expired.job.heartbeat.tengine.failed.tengined
     restart.job.job.tengine.failed.tengined
  ].each do |i|
    describe i do
      it "stuckにする" do
        Tengine::Core::Schedule.delete_all
        Tengine::Job::Runtime::Vertex.delete_all
        builder = Rjn0001SimpleJobnetBuilder.new
        @root = builder.create_actual
        @ctx = builder.context
        @execution = Tengine::Job::Runtime::Execution.create!({
          :root_jobnet_id => @root.id,
        })
        @root.phase_key = :running
        @root.save!
        EM.run_block do
          tengine.receive(i, :properties => {
            :original_event => {
              :event_type_name => "start.job.job.tengine",
              :properties => {
                :execution_id => @execution.id.to_s,
                :root_jobnet_id => @root.id.to_s,
                :root_jobnet_name_path => @root.name_path,
                :target_jobnet_id => @root.id.to_s,
                :target_jobnet_name_path => @root.name_path,
                :target_job_id => @root.children[1].id.to_s,
              }}})
        end
        @root.reload
        @root.children[1].phase_key.should == :stuck
        @root.phase_key.should_not == :stuck # running
      end
    end
  end
end
