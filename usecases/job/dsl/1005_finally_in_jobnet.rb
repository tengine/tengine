
require 'tengine_job'

jobnet("jobnet1005", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  job("job1", "$HOME/tengine_job_test.sh 0 job1")
  finally do
    job("jobnet1005_finally","$HOME/tengine_job_test.sh 0 jobnet1005_finally")
  end
end
