# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet('job_reference_test_6_1', '機能テスト6-1', :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs('u1pj1_jobnet_pattern1', 'u1pj1_jobnet_pattern2')
  expansion('u1pj1_jobnet_pattern1', :to => 'u1pj1_pattern_nothing')
  expansion('u1pj1_jobnet_pattern2', :to => 'u1pj1_pattern_nothing')
  expansion('u1pj1_pattern_nothing')
end
