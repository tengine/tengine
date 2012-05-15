# -*- coding: utf-8 -*-

require 'tengine_job'

# 同じジョブネット名を2回指定しています
jobnet("jobnet0020", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "$HOME/tengine_job_test.sh 0 job1")
  job("job2", "$HOME/tengine_job_test.sh 0 job2")
end

jobnet("jobnet0020", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job3", "$HOME/tengine_job_test.sh 0 job3")
  job("job4", "$HOME/tengine_job_test.sh 0 job4")
end
