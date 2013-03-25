# -*- coding: utf-8 -*-
require 'spec_helper'
require 'timeout'
require 'eventmachine'
require 'json'

describe "tengine_job_agent_run" do

  before(:all) do
    TestRabbitmq.kill_remain_processes
    @test_rabbitmq = TestRabbitmq.new(keep_port: true).launch
  end

  after(:all) do
    TestRabbitmq.kill_launched_processes
  end

  it "execute" do
    cmd = "export MM_SERVER_NAME=localhost MM_ROOT_JOBNET_ID=51483f6d5427dbd49c000001" +
      " MM_TARGET_JOBNET_ID=51483f6d5427dbd49c000001 MM_ACTUAL_JOB_ID=51483f6d5427dbd49c000003" +
      " MM_ACTUAL_JOB_ANCESTOR_IDS=\"51483f6d5427dbd49c000001\" MM_FULL_ACTUAL_JOB_ANCESTOR_IDS=\"51483f6d5427dbd49c000001\"" +
      " MM_ACTUAL_JOB_NAME_PATH=\"/jn0004/j1\" MM_ACTUAL_JOB_SECURITY_TOKEN= MM_SCHEDULE_ID=51483f6d5427dbd49c000018" +
      " MM_SCHEDULE_ESTIMATED_TIME= MM_TEMPLATE_JOB_ID=514800055427db9f6d000003 MM_TEMPLATE_JOB_ANCESTOR_IDS=\"514800055427db9f6d000001\"" +
      " && " + File.expand_path("../../../bin/tengine_job_agent_run", __FILE__) +
      " " + File.expand_path("../actual_spec.sh", __FILE__)

    puts "now calling: #{cmd}"

    timeout(30) do
      fail($?) unless system(cmd)

      EM.run do
        suite = Tengine::Mq::Suite.new
        suite.subscribe do |header, payload|
          hash = JSON.parse(payload)
          event_type_name = hash["event_type_name"]
          puts "event_type_name: " << event_type_name.inspect
          case event_type_name
          when "finished.process.job.tengine" then EM.stop
          when "job.heartbeat.tengine" then
            # OK
          else
            raise "Unknown event_type_name: " << event_type_name.inspect
          end
        end
      end
    end
  end

end
