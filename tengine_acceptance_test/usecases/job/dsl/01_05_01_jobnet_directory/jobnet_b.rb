
require 'tengine_job'

jobnet("jobnet1060_b", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "$HOME/tengine_job_test.sh 0 jobnet1060_b-job1")
end
