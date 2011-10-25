jobnet("jobnet1025", :instance_name => "test_server1", :credential_name => "test_credential1") do
  job("job1", "echo 'job1'", :to => "job2")
  boot_jobs("job1")
  job("job2", "echo 'job2'")
  finally do
    job("job3", "echo 'job3'")
  end
end
