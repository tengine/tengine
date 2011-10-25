jobnet("jobnet1005", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'")
  finally do
    job("jobnet1005_finally","echo 'jobnet1005_finally'")
  end
end
