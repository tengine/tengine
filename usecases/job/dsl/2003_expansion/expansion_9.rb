# -*- coding: utf-8 -*-
jobnet('job_reference_test_6_5', '機能テスト6-5', :vm_instance_name => 'u1pj1_localhost', :credential_name => 'u1_credential_mm') do
  job('job-6-5-1', '~/mm_output.sh 60')
end
