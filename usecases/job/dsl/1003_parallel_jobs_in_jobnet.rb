jobnet("jobnet1003", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1","job2")
  job("job1", "echo 'job1'")
  job("job2", "echo 'job2'")
end
