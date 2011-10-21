jobnet("jobnet1012", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "echo 'job1'")
  finally do
    jobnet("jobnet1012_2", :instance_name => "i-22222222", :credential_name => "goku-ssh-pk2") do
      auto_sequence
      job("job2", "echo 'job2'", :to => "jobnet1012_3")
      jobnet("jobnet1012_3", :instance_name => "i-33333333", :credential_name => "goku-ssh-pk3") do
        auto_sequence
        job("job3", "echo 'job3'")
      end
    end
  end
end
