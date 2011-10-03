jobnet("jobnet1009", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "echo 'job1'")
  jobnet("jobnet1009_2") do
    auto_sequence
    job("job2", "echo 'job2'")
  end
end
