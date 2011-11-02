
require 'tengine_job'

jobnet("jobnet1045", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "$HOME/tengine_job_test.sh 3600 job1"
end
