jobnet("jobnet1012", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  boot_jobs("job1")
  job("job1", "echo 'job1'")
  finally do
    jobnet("jobnet1012_2", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
      boot_jobs("job2")
      job("job2", "echo 'job2'", :to => "jobnet1012_3")
      jobnet("jobnet1012_3", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
        boot_jobs("job3")
        job("job3", "echo 'job3'")
      end
    end
  end
end
