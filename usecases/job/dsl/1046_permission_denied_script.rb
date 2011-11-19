# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("jobnet1046", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1")
  # このジョブネット定義では、tengine_job_permission_denied_test.sh の実行権限がないこと想定しています。
  # 作成にあたっては、tengine_job_test.sh コピーし、実行権限を削除してください。
  job("job1", "$HOME/tengine_job_permission_denied_test.sh 0 job1")
end
