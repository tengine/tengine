jobnet("jobnet1002", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'", :to => "job2")
  job("job2", "echo 'job2'")
end
