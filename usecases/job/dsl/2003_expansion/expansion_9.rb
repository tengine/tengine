# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet('job_reference_test_6_5', '機能テスト6-5', :vm_instance_name => "test_server1", :credential_name => "test_credential1") do
  job('job-6-5-1', '~/mm_output.sh 60')
end
