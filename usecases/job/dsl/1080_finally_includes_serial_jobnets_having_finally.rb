# -*- coding: utf-8 -*-

require 'tengine_job'

# 1080 FinallyにFinally付きのジョブネット(直列)
# [jobnet1080]
#
# [S1]-->[j1]-->[E1]
#                     _______________finally___________________________________________
#                    {                                                                 }
#                    {         _[jobnet1080-1]______     _[jobnet1080-2_______         }
#                    {        {                     }   {                     }        }
#                    {        {                     }   {                     }        }
#                    { [S2]-->{ [S3]-->[j2]-->[E3]  }-->{ [S5]-->[j3]-->[E5]  }-->[E2] }
#                    {        {                     }   {                     }        }
#                    {        {______finally________}   {______finally________}        }
#                    {        {                     }   {                     }        }
#                    {        { [S4]-->[fj1]-->[E4] }   { [S6]-->[fj2]-->[E6] }        }
#                    {        {_____________________}   {_____________________}        }
#                    {                                                                 }
#                    {_________________________________________________________________}

jobnet("jobnet1080", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1","$HOME/tengine_job_test.sh 0 j1")
  finally do
    boot_jobs("jobnet1080-1")
    jobnet("jobnet1080-1", :to => "jobnet1080-2") do 
      boot_jobs("j2")
      job("j2","$HOME/tengine_job_test.sh 0 j2")
      finally do 
        boot_jobs("fj1")
        job("fj1","$HOME/tengine_job_test.sh 0 fj1")
      end
    end
    jobnet("jobnet1080-2") do 
      boot_jobs("j3")
      job("j3","$HOME/tengine_job_test.sh 0 j3")
      finally do 
        boot_jobs("fj2")
        job("fj2","$HOME/tengine_job_test.sh 0 fj2")
      end
    end
  end
end
