
require 'tengine_job'

jobnet("jobnet1037", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'")
  expansion("jobnet1006_2", :to => "job3", :hoge=> "hoge")
  job("job3", "echo 'job3'")
end
jobnet("jobnet1006_2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job2")
  job("job2", "echo 'job2'")
end
