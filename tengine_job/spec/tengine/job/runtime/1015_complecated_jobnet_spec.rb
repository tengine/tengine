require 'spec_helper'
require 'tengine/rspec'

describe Tengine::Job::Runtime::Jobnet do

  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../../../../lib/tengine/job/runtime/drivers/job_control_driver.rb", File.dirname(__FILE__))
  driver :job_control_driver

  before do
    actual_document = {
      "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001cb'),
      "created_at"=>"2011-11-24 14:04:01 UTC",
      "updated_at"=>"2011-11-24 14:04:01 UTC",
      "server_name"=>"test_server1",
      "credential_name"=>"test_credential1",
      "killing_signals"=>nil,
      "killing_signal_interval"=>nil,
      "name"=>"complicated_jobnet",
      "script"=>nil,
      "description"=>"complerated jobnet",
      "jobnet_type_cd"=>1,
      "category_id"=>Moped::BSON::ObjectId('4ea7eafd39efe2347400002e'),
      "version"=>33,
      "dsl_filepath"=>"1015_complicated_jobnet_1.rb",
      "dsl_lineno"=>7,
      "dsl_version"=>"20111124230401",
      "_type"=>"Tengine::Job::Runtime::RootJobnet",
      "phase_cd"=>60,
      "template_id"=>Moped::BSON::ObjectId('4ece4ed139efe2160a000001'),
      "children"=>[
        {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001cc'), "_type"=>"Tengine::Job::Runtime::Start"},
        {"created_at"=>nil, "updated_at"=>nil, "server_name"=>"test_server1", "credential_name"=>"test_credential1", "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet1-1", "script"=>nil, "description"=>"i_jobnet1-1", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001cd'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "children"=>[{"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001ce'), "_type"=>"Tengine::Job::Runtime::Start"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet1-1", "script"=>"$HOME/tengine_job_test.sh 5 jobnet1-1", "description"=>"i_jobnet1-1", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001cf'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "started_at"=>"2011-11-24 15:37:03 UTC", "executing_pid"=>"15836", "exit_status"=>"0", "finished_at"=>"2011-11-24 15:37:11 UTC"},
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d0'), "_type"=>"Tengine::Job::End"}], "edges"=>[{"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d1'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001ce'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001cf')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d2'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001cf'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d0')}], "started_at"=>"2011-11-24 15:37:03 UTC", "finished_at"=>"2011-11-24 15:37:17 UTC"},
        {"created_at"=>nil, "updated_at"=>nil, "server_name"=>"test_server1", "credential_name"=>"test_credential1", "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet1-2", "script"=>nil, "description"=>"i_jobnet1-2", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d3'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "children"=>[{"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d4'), "_type"=>"Tengine::Job::Runtime::Start"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet1-2", "script"=>"$HOME/tengine_job_test.sh 10 jobnet1-2", "description"=>"i_jobnet1-2", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d5'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "started_at"=>"2011-11-24 15:37:03 UTC", "executing_pid"=>"16006", "exit_status"=>"0", "finished_at"=>"2011-11-24 15:37:18 UTC"},
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d6'), "_type"=>"Tengine::Job::End"}], "edges"=>[{"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d7'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d4'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d5')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d8'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d5'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d6')}], "started_at"=>"2011-11-24 15:37:03 UTC", "finished_at"=>"2011-11-24 15:37:19 UTC"}, 
        {"created_at"=>nil, "updated_at"=>nil, "server_name"=>"test_server1", "credential_name"=>"test_credential1", "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet1-3", "script"=>nil, "description"=>"i_jobnet1-3", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d9'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>80, "children"=>[{"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001da'), "_type"=>"Tengine::Job::Runtime::Start"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_job1-1", "script"=>"$HOME/tengine_job_test.sh 1 job1-1", "description"=>"i_job1-1", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001db'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "started_at"=>"2011-11-24 15:37:03 UTC", "executing_pid"=>"16170", "exit_status"=>"0", "finished_at"=>"2011-11-24 15:37:10 UTC"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_job1-2", "script"=>"$HOME/tengine_job_test.sh 1 job1-2", "description"=>"i_job1-2", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001dc'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "started_at"=>"2011-11-24 15:37:03 UTC", "executing_pid"=>"16334", "exit_status"=>"0", "finished_at"=>"2011-11-24 15:37:11 UTC"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_job1-3", "script"=>"$HOME/tengine_job_test.sh 1 job1-3", "description"=>"i_job1-3", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001dd'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "started_at"=>"2011-11-24 15:37:03 UTC", "executing_pid"=>"16499", "exit_status"=>"0", "finished_at"=>"2011-11-24 15:37:13 UTC"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_job2-1", "script"=>"$HOME/tengine_job_failure_test.sh 1 job2-1", "description"=>"i_job2-1", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001de'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>80, "started_at"=>"2011-11-24 15:37:03 UTC", "executing_pid"=>"16665", "exit_status"=>"1", "finished_at"=>"2011-11-24 15:37:14 UTC"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_job2-2", "script"=>"$HOME/tengine_job_test.sh 1 job2-2", "description"=>"i_job2-2", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001df'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "started_at"=>"2011-11-24 15:37:03 UTC", "executing_pid"=>"16830", "exit_status"=>"0", "finished_at"=>"2011-11-24 15:37:16 UTC"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_job2-0", "script"=>"$HOME/tengine_job_test.sh 1 job2-0", "description"=>"i_job2-0", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e0'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>20},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_job3", "script"=>"$HOME/tengine_job_test.sh 1 job3", "description"=>"i_job3", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e1'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>20}, 
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e2'), "_type"=>"Tengine::Job::Fork"},
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e3'), "_type"=>"Tengine::Job::Join"},
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e4'), "_type"=>"Tengine::Job::Join"},
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e5'), "_type"=>"Tengine::Job::End"}], "edges"=>[{"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e6'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001da'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e2')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e7'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e2'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001db')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e8'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e2'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001dc')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e9'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e2'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001dd')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001ea'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e2'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001de')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001eb'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e2'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001df')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001ec'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001db'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e3')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001ed'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001dc'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e3')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001ee'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001dd'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e3')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001ef'), "phase_cd"=>50, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e0'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e3')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f0'), "phase_cd"=>50, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e3'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e1')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f1'), "phase_cd"=>50, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001de'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e4')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f2'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001df'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e4')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f3'), "phase_cd"=>50, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e4'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e0')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f4'), "phase_cd"=>50, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e1'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001e5')}], "started_at"=>"2011-11-24 15:37:03 UTC", "finished_at"=>"2011-11-24 15:37:18 UTC"},
        {"created_at"=>nil, "updated_at"=>nil, "server_name"=>"test_server1", "credential_name"=>"test_credential1", "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet2-1", "script"=>nil, "description"=>"i_jobnet2-1", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f5'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "children"=>[{"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f6'), "_type"=>"Tengine::Job::Runtime::Start"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet2-1", "script"=>"$HOME/tengine_job_test.sh 1 jobnet2-1", "description"=>"i_jobnet2-1", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f7'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>40, "started_at"=>"2011-11-24 15:37:03 UTC", "executing_pid"=>"16995", "exit_status"=>"0", "finished_at"=>"2011-11-24 15:37:18 UTC"},
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f8'), "_type"=>"Tengine::Job::End"}], "edges"=>[{"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f9'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f6'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f7')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fa'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f7'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f8')}], "started_at"=>"2011-11-24 15:37:03 UTC", "finished_at"=>"2011-11-24 15:37:18 UTC"},
        {"created_at"=>nil, "updated_at"=>nil, "server_name"=>"test_server1", "credential_name"=>"test_credential1", "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet2-2", "script"=>nil, "description"=>"i_jobnet2-2", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fb'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>60, "children"=>[{"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fc'), "_type"=>"Tengine::Job::Runtime::Start"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet2-2", "script"=>"$HOME/tengine_job_test.sh 1 jobnet2-2", "description"=>"i_jobnet2-2", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fd'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>60, "started_at"=>"2011-11-24 15:37:04 UTC", "executing_pid"=>"17160"},
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fe'), "_type"=>"Tengine::Job::End"}], "edges"=>[{"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001ff'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fc'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fd')}, 
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000200'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fd'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fe')}], "started_at"=>"2011-11-24 15:37:03 UTC"}, 
        {"created_at"=>nil, "updated_at"=>nil, "server_name"=>"test_server1", "credential_name"=>"test_credential1", "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet2-0", "script"=>nil, "description"=>"i_jobnet2-0", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000201'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>20, "children"=>[{"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000202'), "_type"=>"Tengine::Job::Runtime::Start"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet2-0", "script"=>"$HOME/tengine_job_test.sh 1 jobnet2-0", "description"=>"i_jobnet2-0", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000203'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>20}, 
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000204'), "_type"=>"Tengine::Job::End"}], "edges"=>[{"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000205'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000202'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000203')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000206'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000203'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000204')}]},
        {"created_at"=>nil, "updated_at"=>nil, "server_name"=>"test_server1", "credential_name"=>"test_credential1", "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet3", "script"=>nil, "description"=>"i_jobnet3", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000207'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>20, "children"=>[{"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000208'), "_type"=>"Tengine::Job::Runtime::Start"},
            {"created_at"=>nil, "updated_at"=>nil, "server_name"=>nil, "credential_name"=>nil, "killing_signals"=>nil, "killing_signal_interval"=>nil, "name"=>"i_jobnet3", "script"=>"$HOME/tengine_job_test.sh 1 jobnet3", "description"=>"i_jobnet3", "jobnet_type_cd"=>1, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000209'), "_type"=>"Tengine::Job::Runtime::Jobnet", "phase_cd"=>20},
            {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020a'), "_type"=>"Tengine::Job::End"}], "edges"=>[{"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020b'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000208'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000209')},
            {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020c'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000209'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020a')}]},
        {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020d'), "_type"=>"Tengine::Job::Fork"},
        {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020e'), "_type"=>"Tengine::Job::Join"},
        {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020f'), "_type"=>"Tengine::Job::Join"},
        {"created_at"=>nil, "updated_at"=>nil, "_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000210'), "_type"=>"Tengine::Job::End"}], "edges"=>[{"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000211'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001cc'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020d')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000212'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020d'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001cd')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000213'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020d'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d3')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000214'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020d'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d9')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000215'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020d'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f5')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000216'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020d'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fb')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000217'), "phase_cd"=>20, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001cd'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020e')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000218'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d3'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020e')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000219'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001d9'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020e')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000021a'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000201'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020e')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000021b'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020e'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000207')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000021c'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001f5'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020f')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000021d'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d00001fb'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020f')},
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000021e'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000020f'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000201')}, 
        {"_id"=>Moped::BSON::ObjectId('4ece649e39efe202d000021f'), "phase_cd"=>0, "origin_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000207'), "destination_id"=>Moped::BSON::ObjectId('4ece649e39efe202d0000210')}
      ], "started_at"=>"2011-11-24 15:37:03 UTC"}

    Tengine::Job::Runtime::Vertex.delete_all
    Tengine::Job::Runtime::Vertex.collection.insert(actual_document)
    @root = Tengine::Job::Runtime::Vertex.first
    @parent = @root.vertex_by_name_path("/complicated_jobnet/i_jobnet1-3")
    @failure_job = @root.vertex_by_name_path("/complicated_jobnet/i_jobnet1-3/i_job2-1")
    @execution = Tengine::Job::Runtime::Execution.create!({
        :root_jobnet_id => @root.id,
      })
  end

  it do
    @root.phase_key.should == :running
    @root.element("i_jobnet1-1").phase_key.should == :success    ; @root.element("next!i_jobnet2-1").phase_key.should == :active
    @root.element("i_jobnet1-2").phase_key.should == :success    ; @root.element("next!i_jobnet2-1").phase_key.should == :active
    @parent.phase_key.should == :error
    @parent.element("i_job1-1").phase_key.should == :success     ; @parent.element("next!i_job1-1").phase_key.should == :transmitted
    @parent.element("i_job1-2").phase_key.should == :success     ; @parent.element("next!i_job1-2").phase_key.should == :transmitted
    @parent.element("i_job1-3").phase_key.should == :success     ; @parent.element("next!i_job1-3").phase_key.should == :transmitted
    @parent.element("i_job2-1").phase_key.should == :error       ; @parent.element("next!i_job2-1").phase_key.should == :closed
    @parent.element("i_job2-2").phase_key.should == :success     ; @parent.element("next!i_job2-2").phase_key.should == :transmitted
    @parent.element("i_job2-0").phase_key.should == :initialized ; @parent.element("next!i_job2-0").phase_key.should == :closed
    @parent.element("i_job3").phase_key.should == :initialized   ; @parent.element("next!i_job3").phase_key.should == :closed
    @root.element("i_jobnet2-1").phase_key.should == :success    ; @root.element("next!i_jobnet2-1").phase_key.should == :active
    @root.element("i_jobnet2-2").phase_key.should == :running    ; @root.element("next!i_jobnet2-2").phase_key.should == :active
    @root.element("i_jobnet2-0").phase_key.should == :initialized; @root.element("next!i_jobnet2-0").phase_key.should == :active
    @root.element("i_jobnet3").phase_key.should == :initialized  ; @root.element("next!i_jobnet3").phase_key.should == :active

    tengine.should_not_fire

    # D, [2011-11-25T00:37:19.301707 #15640] DEBUG -- : received an event #<Tengine::Event:0x000001019e5618
    # @properties={"target_jobnet_id"=>"4ece649e39efe202d00001d9", "execution_id"=>"4ece649e39efe202d0000220", "root_jobnet_id"=>"4ece649e39efe202d00001cb"},
    # @event_type_name="error.jobnet.job.tengine", @key="1e2aec50-f8e0-012e-4a45-482a140dece2",
    # @source_name="job:cloud-dev-6.local/15640/4ece649e39efe202d00001cb/4ece649e39efe202d00001d9",
    # @sender_name="cloud-dev-6.local/15640", @level=2, @occurred_at=2011-11-24 15:37:19 UTC>
    tengine.receive("error.jobnet.job.tengine", :properties => {
        :execution_id => @execution.id.to_s,
        :root_jobnet_id => @root.id.to_s,
        :target_jobnet_id => @parent.id.to_s,
      })

    @root.reload
    @root.phase_key.should == :running
    @root.element("i_jobnet1-1").phase_key.should == :success    ; @root.element("next!i_jobnet2-1").phase_key.should == :active
    @root.element("i_jobnet1-2").phase_key.should == :success    ; @root.element("next!i_jobnet2-1").phase_key.should == :active
    @parent.phase_key.should == :error
    @parent.element("i_job1-1").phase_key.should == :success     ; @parent.element("next!i_job1-1").phase_key.should == :transmitted
    @parent.element("i_job1-2").phase_key.should == :success     ; @parent.element("next!i_job1-2").phase_key.should == :transmitted
    @parent.element("i_job1-3").phase_key.should == :success     ; @parent.element("next!i_job1-3").phase_key.should == :transmitted
    @parent.element("i_job2-1").phase_key.should == :error       ; @parent.element("next!i_job2-1").phase_key.should == :closed
    @parent.element("i_job2-2").phase_key.should == :success     ; @parent.element("next!i_job2-2").phase_key.should == :transmitted
    @parent.element("i_job2-0").phase_key.should == :initialized ; @parent.element("next!i_job2-0").phase_key.should == :closed
    @parent.element("i_job3").phase_key.should == :initialized   ; @parent.element("next!i_job3").phase_key.should == :closed
    @root.element("i_jobnet2-1").phase_key.should == :success    ; @root.element("next!i_jobnet2-1").phase_key.should == :active
    @root.element("i_jobnet2-2").phase_key.should == :running    ; @root.element("next!i_jobnet2-2").phase_key.should == :active
    @root.element("i_jobnet2-0").phase_key.should == :initialized; @root.element("next!i_jobnet2-0").phase_key.should == :active
    @root.element("i_jobnet3").phase_key.should == :initialized  ; @root.element("next!i_jobnet3").phase_key.should == :closing
  end

end
