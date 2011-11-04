# -*- coding: utf-8 -*-

require 'tengine_job'

# 1079 FinallyにFinally付きのジョブネット１つ
# [jobnet1079]
#
# [S1]-->[j1]-->[E1]
#                     _______________finally_________________
#                    {                                       }
#                    {         _[jobnet1079]________         }
#                    {        {                     }        }
#                    {        {                     }        }
#                    { [S2]-->{ [S3]-->[j2]-->[E3]  }-->[E2] }
#                    {        {                     }        }
#                    {        {______finally________}        }
#                    {        {                     }        }
#                    {        { [S4]-->[fj1]-->[E4] }        }
#                    {        {_____________________}        }
#                    {                                       }
#                    {_______________________________________}

jobnet("jobnet1079", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1","$HOME/tengine_job_test.sh 0 j1")
  finally do
    boot_jobs("jobnet1079")
    jobnet("jobnet1079") do 
      boot_jobs("j2")
      job("j2","$HOME/tengine_job_test.sh 0 j2")
      finally do 
        boot_jobs("fj1")
        job("fj1","$HOME/tengine_job_test.sh 0 fj1")
      end
    end
  end
end
