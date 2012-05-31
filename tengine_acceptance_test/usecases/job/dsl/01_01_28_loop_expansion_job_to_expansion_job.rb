
require 'tengine_job'

jobnet("jobnet1053", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "jobnet1053_2")
  expansion("jobnet1053_2", :to => "job3")
  job("job3", "$HOME/tengine_job_test.sh 0 job3")
end
jobnet("jobnet1053_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job2")
  job("job2", "$HOME/tengine_job_test.sh 0 job2", :to => "jobnet1053")
  expansion("jobnet1053")
end
