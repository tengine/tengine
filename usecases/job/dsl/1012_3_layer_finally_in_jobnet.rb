jobnet("jobnet1012", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "echo 'job1'")
  finally do
    jobnet("jobnet1012_2") do
      auto_sequence
      job("job2", "echo 'job2'", :to => "jobnet1012_3")
      jobnet("jobnet1012_3") do
        auto_sequence
        job("job3", "echo 'job3'")
      end
    end
  end
end
