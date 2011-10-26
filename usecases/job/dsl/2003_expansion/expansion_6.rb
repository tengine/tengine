# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet('job_reference_test_6_3_1', '機能テスト6-3-1', :vm_instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs('job6-3-1')
  job('job6-3-1', '~/mm_server/spec/models/job/mm_job.sh 30 job_function_test_6-3-1', :to => 'job_reference_test_6_3_2')
  expansion('job_reference_test_6_3_2', :to => 'job6-3-3')
  job('job6-3-3', '~/mm_server/spec/models/job/mm_job.sh 30 job_function_test_6-3-3')
end
