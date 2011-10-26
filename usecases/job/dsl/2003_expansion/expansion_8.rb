# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet('job_reference_test_6_4', '機能テスト6-4', :vm_instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job('job6-4-1', '~/mm_server/spec/models/job/mm_job.sh 30 job_function_test_6-4-1')
  expansion('job_reference_test_6_4')
  job('job6-4-3', '~/mm_server/spec/models/job/mm_job.sh 30 job_function_test_6-4-3')
end
