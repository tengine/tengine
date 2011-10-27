# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("u1pj1_jobnet_pattern1", "テスト用ジョブネットパターン1", :vm_instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  jobnet("jobnet_pt11") do
    auto_sequence
    job("job_pt111", "echo 'success111'")
    job("job_pt112", "echo 'success112'")
  end
  jobnet("jobnet_pt12") do
    auto_sequence
    job("job_pt121", "echo 'success121'")
    job("job_pt122", "echo 'success122'")
  end
  jobnet("jobnet_pt13") do
    auto_sequence
    job("job_pt131", "echo 'success131'")
    job("job_pt132", "echo 'success132'")
  end
end
