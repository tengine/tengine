jobnet("jobnet1022", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'")
  finally do
    hadoop_job("hadoop_job1")
  end
end
