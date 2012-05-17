
require 'tengine_job'

jobnet("jobnet1008", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "$HOME/tengine_job_test.sh 0 job1")
  job("job2", "$HOME/tengine_job_test.sh 0 job2")
  job("job3", "$HOME/tengine_job_test.sh 0 job3")
end
