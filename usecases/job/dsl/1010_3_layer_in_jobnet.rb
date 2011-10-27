
require 'tengine_job'

jobnet("jobnet1010", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "echo 'job1'")
  jobnet("jobnet1010_2") do
    auto_sequence
    job("job2", "echo 'job2'")
    jobnet("jobnet1010_3") do
      auto_sequence
      job("job3", "echo 'job3'")
    end
  end
end
