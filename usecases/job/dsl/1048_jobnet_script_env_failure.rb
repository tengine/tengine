# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("jobnet1048_failure", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  jobnet("jobnet1048_2") do
    job("job1", "exit 1"
  end
  finally do
    job("jobnet1048_finally","$HOME/tengine_job_env_test.sh 0 jobnet1048_finally")
  end
end
