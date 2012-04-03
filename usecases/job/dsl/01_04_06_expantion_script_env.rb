
require 'tengine_job'

jobnet("jobnet1049", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  expansion("jobnet1049_2")
end


jobnet("jobnet1049_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "$HOME/tengine_job_env_test.sh 0 job1")
end
