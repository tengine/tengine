
require 'tengine_job'

jobnet("jobnet1003", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1","job2")
  job("job1", "$HOME/tengine_job_test.sh 0 job1")
  job("job2", "$HOME/tengine_job_test.sh 0 job2")
end
