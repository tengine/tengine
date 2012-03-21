require 'tengine_job'

dsl_version("0.9.7")

jobnet("jobnet1050", :server_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "$HOME/tengine_job_test.sh 1 job1")
end
