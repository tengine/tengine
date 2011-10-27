
require 'tengine_job'

jobnet("jobnet1062_c", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")x
  job("job1", "echo 'job1'")
end
