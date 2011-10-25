jobnet("jobnet1013", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "echo 'job1'")
  jobnet("jobnet1010_2", :instance_name => "test_server2", :credential_name => "test_credential2") do
    auto_sequence
    job("job2", "echo 'job2'")
    jobnet("jobnet1010_3", :instance_name => "test_server3", :credential_name => "test_credential3") do
      auto_sequence
      job("job3", "echo 'job3'")
    end
  end
end
