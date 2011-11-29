# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("jobnet1048_finally_failure", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  jobnet("jobnet1048_2") do
    job("job1", "exit 1")
  end
  finally do
    jobnet("jobnet1048_2_finally_jobnet") do
      job("jobnet1048_finally","exit 1")
      finally do
        job("jobnet1048_finally_in_finally","$HOME/tengine_job_env_test.sh 0 jobnet1048_finally_in_finally")
      end
    end
  end
end
