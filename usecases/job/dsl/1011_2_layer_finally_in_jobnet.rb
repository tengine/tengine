
require 'tengine_job'

jobnet("jobnet1011", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "echo 'job1'")
  finally do
    jobnet("jobnet1011_2") do
      auto_sequence
      job("job2", "echo 'job2'")
    end
  end
end
