jobnet("jobnet1051_i", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'")
end
