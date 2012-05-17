# -*- coding: utf-8 -*-

require 'tengine_job'

# 1074 ルートジョブネットがFinally付きのジョブネット(並列)
# [jobnet1074]
#
#            {-[jobnet1074-1]-------}
#            {                      }
#        |-->{  [S2]-->[j1]-->[E2]  }-->|
#        |   {                      }   |
#        |   {________finally_______}   |
#        |   {                      }   |
#        |   { [S3]-->[jf1]-->[E3]  }   |
#        |   {                      }   |
#        |   {----------------------}   |
#        |                              |
# [S1]-->F                              J-->[E1]
#        |                              |
#        |   {-[jobnet1074-2]-------}   |
#        |   {                      }   |
#        |-->{  [S4]-->[j2]-->[E4]  }-->|
#            {                      }
#            {________finally_______}
#            {                      }
#            { [S5]-->[jf2]-->[E5]  }
#            {                      }
#            {----------------------}
#
#                     ______________finally_____________
#                    {                                  }
#                    {[S4]-->[jobnet1074_finally]-->[E4]}
#                    {__________________________________}

jobnet("jobnet1074", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("jobnet1074-1","jobnet1074-2")
  jobnet("jobnet1074-1") do 
    boot_jobs("j1")
    job("j1", "$HOME/tengine_job_test.sh 0 j1")
    finally do 
      boot_jobs("jf1")
      job("jf1", "$HOME/tengine_job_test.sh 0 jf1")
    end
  end
  jobnet("jobnet1074-2") do 
    boot_jobs("j2")
    job("j2", "$HOME/tengine_job_test.sh 0 j2")
    finally do 
      boot_jobs("jf2")
      job("jf2", "$HOME/tengine_job_test.sh 0 jf2")
    end
  end
  finally do
    job("jobnet1074_finally","$HOME/tengine_job_test.sh 0 jobnet1074_finally")
  end
end
