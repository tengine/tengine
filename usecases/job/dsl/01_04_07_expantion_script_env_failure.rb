
require 'tengine_job'

jobnet("jobnet1049_failure", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  expansion("jobnet1049_2")
  finally do
    job("jobnet1049_finally","$HOME/tengine_job_env_test.sh 0 jobnet1049_finally")
  end
end


jobnet("jobnet1049_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "exit 1")
end
