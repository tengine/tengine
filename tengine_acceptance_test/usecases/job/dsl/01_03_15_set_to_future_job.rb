
require 'tengine_job'

jobnet("jobnet1040", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "$HOME/tengine_job_test.sh 0 job1" , :to => ["job2","job3"])
  job("job2", "$HOME/tengine_job_test.sh 0 job2" , :to => "job3")
  job("job3", "$HOME/tengine_job_test.sh 0 job3")
end
