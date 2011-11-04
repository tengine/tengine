
require 'tengine_job'

jobnet("jobnet1034", :instance_name => "test_server1", :credential_name => "test_credential1" ,:hoge => "hoge") do
  auto_sequence
  job("job1", "$HOME/tengine_job_test.sh 0 job1")
end
