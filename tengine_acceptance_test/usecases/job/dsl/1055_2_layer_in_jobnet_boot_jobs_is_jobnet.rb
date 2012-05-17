require 'tengine_job'

jobnet("jobnet1055", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  jobnet("jobnet1055_2") do
    auto_sequence
    job("job1", "$HOME/tengine_job_test.sh 0 job2")
  end
end
