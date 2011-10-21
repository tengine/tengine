jobnet("jobnet1001", :instance_name => "i-11111111", :credential_name => "not_registered") do
  boot_jobs("job1")
  job("job1", "echo 'job1'")
end
