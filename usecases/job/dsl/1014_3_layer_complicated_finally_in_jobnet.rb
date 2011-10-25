jobnet("jobnet1012", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "echo 'job1'")
  finally do
    jobnet("jobnet1012_2", :instance_name => "test_server2", :credential_name => "test_credential2") do
      auto_sequence
      job("job2", "echo 'job2'", :to => "jobnet1012_3")
      jobnet("jobnet1012_3", :instance_name => "test_server3", :credential_name => "test_credential3") do
        auto_sequence
        job("job3", "echo 'job3'")
      end
    end
  end
end
