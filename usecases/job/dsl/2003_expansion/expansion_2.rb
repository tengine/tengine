# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("u1pj1_jobnet_pattern2", "テスト用ジョブネットパターン2", :vm_instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("jobnet_pt21")
  jobnet("jobnet_pt21", :to => ["jobnet_pt22", "jobnet_pt23"]) do
    auto_sequence
    job("job_pt211", "echo 'success211'")
    job("job_pt212", "echo 'success212'")
  end
  jobnet("jobnet_pt22", :to => "jobnet_pt24") do
    auto_sequence
    job("job_pt221", "echo 'success221'")
    job("job_pt222", "echo 'success222'")
  end
  jobnet("jobnet_pt23", :to => "jobnet_pt24") do
    auto_sequence
    job("job_pt231", "echo 'success231'")
    job("job_pt232", "echo 'success232'")
  end
  jobnet("jobnet_pt24") do
    auto_sequence
    job("job_pt241", "echo 'success241'")
    job("job_pt242", "echo 'success242'")
  end
end
