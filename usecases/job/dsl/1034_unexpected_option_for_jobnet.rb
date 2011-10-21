jobnet("jobnet1034", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1" ,:hoge => "hoge") do
  auto_sequence
  job("job1", "echo 'job1'")
end
