jobnet("jobnet1042", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "echo 'job1-1'")
  jobnet("jobnet1042_2") do
    auto_sequence
    job("job1", "echo 'job1-2'")
  end
end
