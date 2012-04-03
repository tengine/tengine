# -*- coding: utf-8 -*-

require 'tengine_job'

# 1072 ルートジョブネットがFinally付きのジョブネット１つ
# [jobnet1072]
#
#        {-[jobnet1072-1]-------------------------}
#        {                                        }
# [S1]-->{        [S2]-->[job1]-->[E2]            }-->[E1]
#        {                                        }
#        {____________finally_____________________}
#        {                                        }
#        { [S3]-->[jobnet1072-1_finally]-->[E3]   }
#        {                                        }
#        {----------------------------------------}
#
#                     ______________finally_____________
#                    {                                  }
#                    {[S4]-->[jobnet1072_finally]-->[E4]}
#                    {__________________________________}

jobnet("jobnet1072", :instance_name => "test_server1", :credential_name => "test_credential1") do
  jobnet("jobnet1072-1") do 
    boot_jobs("job1")
    job("job1", "$HOME/tengine_job_test.sh 0 job1")
    finally do 
      boot_jobs("jobnet1072-1_finally")
      job("jobnet1072-1_finally", "$HOME/tengine_job_test.sh 0 jobnet1072-1_finally")
    end
  end
  finally do
    job("jobnet1072_finally","$HOME/tengine_job_test.sh 0 jobnet1072_finally")
  end
end
