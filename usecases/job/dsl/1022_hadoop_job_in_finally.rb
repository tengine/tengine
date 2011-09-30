jobnet("jobnet1022", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'")
  finally do
    hadoop_job("hadoop_job1")
  end
end
