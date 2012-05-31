
require 'tengine_job'

jobnet("jobnet1043", :instance_name => "not_registered", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "$HOME/tengine_job_test.sh 0 job1")
end
