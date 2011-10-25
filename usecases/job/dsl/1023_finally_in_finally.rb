
require 'tengine_job'

jobnet("jobnet1023", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'")
  finally do
    finally do
      job("job2", "echo 'job2'")
    end
  end
end
