# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("jobnet1047", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  # このジョブネット定義では、tengine_job_no_such_script_test.sh は、存在しないことを想定しています。
  job("job1", "$HOME/tengine_job_no_such_script_test.sh 0 job1")
end
