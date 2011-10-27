
require 'tengine_job'

jobnet("jobnet1026", :instance_name => "test_server1", :credential_name => "test_credential1") do
  job("job1", "echo 'job1'", :to => "job2")
  auto_sequence
  job("job2", "echo 'job2'")
  job("job3", "echo 'job3'")
end
