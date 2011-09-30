jobnet("jobnet1006", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'")
  expansion("jobnet1006_2", :to => "job3")
  job("job3", "echo 'job3'")
end
jobnet("jobnet1006_2", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("job2")
  job("job2", "echo 'job2'")
end
