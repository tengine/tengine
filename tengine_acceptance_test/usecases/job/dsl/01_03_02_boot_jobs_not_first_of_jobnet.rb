
require 'tengine_job'

jobnet("jobnet1025", :instance_name => "test_server1", :credential_name => "test_credential1") do
  job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "job2")
  boot_jobs("job1")
  job("job2", "$HOME/tengine_job_test.sh 0 job2")
  finally do
    job("job3", "$HOME/tengine_job_test.sh 0 job3")
  end
end
