# -*- coding: utf-8 -*-

require 'tengine_job'

# 1071 ルートジョブネットが複数のジョブ(並列)を含むジョブネット
# [jobnet1071]
#
#        |-->[job1]-->|
#        |            |
# [S1]-->|            |-->[E1]
#        |            |
#        |-->[job2]-->|
#
#                     ______________finally_____________
#                    {                                  }
#                    {[S2]-->[jobnet1071_finally]-->[E2]}
#                    {__________________________________}

jobnet("jobnet1071", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("job1","job2")
  job("job1", "$HOME/tengine_job_test.sh 0 job1")
  job("job2", "$HOME/tengine_job_test.sh 0 job2")
  finally do
    job("jobnet1071_finally","$HOME/tengine_job_test.sh 0 jobnet1071_finally")
  end
end
