# -*- coding: utf-8 -*-

require 'tengine_job'

# 1075 ルートジョブネットがFinally付きのジョブネット入れ子3層
# [jobnet1075]
#
#          {-[jobnet1075-1]------------------------------------------}
#          {                                                         }
#          {        {-[jobnet1075-2]------------------------}        }
#          {        {                                       }        }
#          {        {        {-[jobnet1075-3]------}        }        }
#          {        {        {                     }        }        }
#   [S1]-->{ [S2]-->{ [S4]-->{ [S6]-->[j3]-->[E6]  }-->[E4] }-->[E2] }-->[E1]
#          {        {        {                     }        }        }
#          {        {        {_______finally_______}        }        }
#          {        {        {                     }        }        }
#          {        {        { [S7]-->[jf3]-->[E7] }        }        }
#          {        {        {_____________________}        }        }
#          {        {                                       }        }
#          {        {________________finally________________}        }
#          {        {                                       }        }
#          {        {          [S5]-->[jf2]-->[E5]          }        }
#          {        {_______________________________________}        }
#          {                                                         }
#          {_________________________finally_________________________}
#          {                                                         }
#          {                   [S3]-->[jf1]-->[E3]                   }
#          {---------------------------------------------------------}
#
#                      ______________finally_____________
#                     {                                  }
#                     {[S4]-->[jobnet1075_finally]-->[E4]}
#                     {__________________________________}

jobnet("jobnet1075", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("jobnet1075-1")
  jobnet("jobnet1075-1") do 
    boot_jobs("jobnet1075-2")
    jobnet("jobnet1075-2") do 
      boot_jobs("jobnet1075-3")
      jobnet("jobnet1075-3") do 
        boot_jobs("j3")
        job("j3","$HOME/tengine_job_test.sh 0 j3")
        finally do 
          boot_jobs("jf3")
          job("jf3", "$HOME/tengine_job_test.sh 0 jf3")
        end
      end
      finally do 
        boot_jobs("jf2")
        job("jf2", "$HOME/tengine_job_test.sh 0 jf2")
      end
    end
    finally do 
      boot_jobs("jf1")
      job("jf1", "$HOME/tengine_job_test.sh 0 jf1")
    end
  end
  finally do
    job("jobnet1075_finally","$HOME/tengine_job_test.sh 0 jobnet1075_finally")
  end
end
