# -*- coding: utf-8 -*-

require 'tengine_job'

# 1091 Finally付きのジョブネット(並列)を組み合わせた複雑なパターン
# [jobnet1091]
#
#            {-[jobnet1091-1]-------}
#            {                      }
#        |-->{  [S2]-->[j1]-->[E2]  }-->|
#        |   {                      }   |
#        |   {________finally_______}   |
#        |   {                      }   |
#        |   { [S3]-->[fj1]-->[E3]  }   |
#        |   {                      }   |
#        |   {----------------------}   |
#        |                              |
# [S1]-->F                              J-->[E1]
#        |                              |
#        |   {-[jobnet1091-2]-------}   |
#        |   {                      }   |
#        |-->{  [S4]-->[j2]-->[E4]  }-->|
#            {                      }
#            {________finally_______}
#            {                      }
#            { [S5]-->[fj2]-->[E5]  }
#            {                      }
#            {----------------------}
#
#                     _______________finally________________________
#                    {                                               }
#                    {             _[jobnet1091-3]______             }
#                    {            {                     }            }
#                    {            {                     }            }
#                    {        |-->{ [S7]-->[j3]-->[E7]  }-->|        }
#                    {        |   {                     }   |        }
#                    {        |   {______finally________}   |        }
#                    {        |   {                     }   |        }
#                    {        |   { [S8]-->[fj3]-->[E8] }   |        }
#                    {        |   {_____________________}   |        }
#                    {        |                             |        }
#                    { [S6]-->F                             J-->[E6] }
#                    {        |    _[jobnet1091-4]______    |        }
#                    {        |   {                     }   |        }
#                    {        |   {                     }   |        }
#                    {        |-->{ [S9]-->[j4]-->[E9]  }-->|        }
#                    {            {                     }            }
#                    {            {______finally________}            }
#                    {            {                     }            }
#                    {            {[S10]-->[fj4]-->[E10]}            }
#                    {            {_____________________}            }
#                    {                                               }
#                    {_______________________________________________}

jobnet("jobnet1091", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("jobnet1091-1","jobnet1091-2")
  jobnet("jobnet1091-1", :instance_name => "test_server2", :credential_name => "test_credential2") do 
    boot_jobs("j1")
    job("j1", "$HOME/tengine_job_test.sh 0 j1")
    finally do 
      boot_jobs("fj1")
      job("fj1", "$HOME/tengine_job_test.sh 0 fj1")
    end
  end
  jobnet("jobnet1091-2", :instance_name => "test_server3", :credential_name => "test_credential3") do 
    boot_jobs("j2")
    job("j2", "$HOME/tengine_job_test.sh 0 j2")
    finally do 
      boot_jobs("fj2")
      job("fj2", "$HOME/tengine_job_test.sh 0 fj2")
    end
  end
  finally do
    boot_jobs("jobnet1091-3","jobnet1091-4")
    jobnet("jobnet1091-3") do 
      boot_jobs("j3")
      job("j3","$HOME/tengine_job_test.sh 0 j3")
      finally do 
        boot_jobs("fj3")
        job("fj3","$HOME/tengine_job_test.sh 0 fj3")
      end
    end
    jobnet("jobnet1091-4") do 
      boot_jobs("j4")
      job("j4","$HOME/tengine_job_test.sh 0 j4")
      finally do 
        boot_jobs("fj4")
        job("fj4","$HOME/tengine_job_test.sh 0 fj4")
      end
    end
  end
end
