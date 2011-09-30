jobnet("jobnet1011", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  boot_jobs("job1")
  job("job1", "echo 'job1'")
  finally do
    jobnet("jobnet1011_2", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
      boot_jobs("job2")
      job("job2", "echo 'job2'")
    end
  end
end
