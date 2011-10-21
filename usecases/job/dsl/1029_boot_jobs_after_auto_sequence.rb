jobnet("jobnet1029", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  boot_jobs("job1")
  job("job1", "echo 'job1'")
  job("job2", "echo 'job2'")
  job("job3", "echo 'job3'")
end
