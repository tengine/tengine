
require 'tengine_job'

jobnet("jobnet1052", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "$HOME/tengine_job_test.sh 0 job1", :to => "jobnet1052_2")
  expansion("jobnet1052_2", :to => "jobnet1052_3")
  expansion("jobnet1052_3", :to => "jobnet1052_2")
end
jobnet("jobnet1052_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job2")
  job("job2", "$HOME/tengine_job_test.sh 0 job2")
end
jobnet("jobnet1052_3", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job3")
  job("job3", "$HOME/tengine_job_test.sh 0 job2")
end
