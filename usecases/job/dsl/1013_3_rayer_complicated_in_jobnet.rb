jobnet("jobnet1013", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "echo 'job1'")
  jobnet("jobnet1010_2", :instance_name => "i-22222222", :credential_name => "goku-ssh-pk2") do
    auto_sequence
    job("job2", "echo 'job2'")
    jobnet("jobnet1010_3", :instance_name => "i-33333333", :credential_name => "goku-ssh-pk3") do
      auto_sequence
      job("job3", "echo 'job3'")
    end
  end
end
