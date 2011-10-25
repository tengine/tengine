jobnet("jobnet1024", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'", :to => "job3")
  finally do
    job("job2", "echo 'job2'")
  end
  job("job3", "echo 'job3'")
end
