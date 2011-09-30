jobnet("jobnet1026", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  job("job1", "echo 'job1'", :to => "job2")
  auto_sequence
  job("job2", "echo 'job2'")
  job("job3", "echo 'job3'")
end
