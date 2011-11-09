
require 'tengine_job'

jobnet("jobnet1060_e", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "$HOME/tengine_job_test.sh 0 jobnet1060_e-job1")
end
