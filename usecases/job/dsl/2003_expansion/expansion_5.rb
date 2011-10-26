# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet('job_reference_test_6_2', '機能テスト6-2', :vm_instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs('job6-2-1')
  job('job6-2-1', '~/mm_server/spec/models/job/mm_job.sh 30 job_function_test_6-2-1', :to => ['job6-2-2', 'job6-2-3'])
  job('job6-2-2', '~/mm_server/spec/models/job/mm_job.sh 30 job_function_test_6-2-2', :to => 'job6-2-4')
  job('job6-2-3', '~/mm_server/spec/models/job/mm_job.sh 30 job_function_test_6-2-3', :to => 'job6-2-4')
  job('job6-2-4', '~/mm_server/spec/models/job/mm_job.sh 30 job_function_test_6-2-4', :to => 'job6-2-3')
end
