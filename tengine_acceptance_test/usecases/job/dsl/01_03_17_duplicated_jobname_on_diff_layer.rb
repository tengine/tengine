
require 'tengine_job'

jobnet("jobnet1042", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "$HOME/tengine_job_test.sh 0 job1-1")
  jobnet("jobnet1042_2") do
    auto_sequence
    job("job1", "$HOME/tengine_job_test.sh 0 job1-2")
  end
end
