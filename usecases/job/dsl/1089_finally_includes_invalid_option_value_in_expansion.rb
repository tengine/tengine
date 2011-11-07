# -*- coding: utf-8 -*-

require 'tengine_job'

# 1089 Finallyにexpansionのoptionに不正な値
# [jobnet1089]
#
# [S1]-->[j1]-->[E1]
#                     _______________finally________________________
#                    {                                               }
#                    {             _[jobnet1089]________             }
#                    {            {                     }            }
#                    {            {                     }            }
#                    {        |-->{ [S3]-->[j2]-->[E3]  }-->|        }
#                    {        |   {                     }   |        }
#                    {        |   {______finally________}   |        }
#                    {        |   {                     }   |        }
#                    {        |   { [S4]-->[fj1]-->[E4] }   |        }
#                    {        |   {_____________________}   |        }
#                    {        |                             |        }
#                    { [S2]-->F                             J-->[E2] }
#                    {        |    _[jobnet1089]________    |        }
#                    {        |   {                     }   |        }
#                    {        |   {                     }   |        }
#                    {        |-->{ [S3]-->[j2]-->[E3]  }-->|        }
#                    {            {                     }            }
#                    {            {______finally________}            }
#                    {            {                     }            }
#                    {            { [S4]-->[fj1]-->[E4] }            }
#                    {            {_____________________}            }
#                    {                                               }
#                    {_______________________________________________}

jobnet("jobnet1089", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1","$HOME/tengine_job_test.sh 0 j1")
  finally do
    auto_sequence
    expansion("jobnet1089-1", :hoge => "hoge")
    expansion("jobnet1089-2", :fuga => "fuga")
  end
end

jobnet("jobnet1089-1", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j2")
  job("j2","$HOME/tengine_job_test.sh 0 j2")
  finally do 
    boot_jobs("fj1")
    job("fj1","$HOME/tengine_job_test.sh 0 fj1")
  end
end

jobnet("jobnet1089-2", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j3")
  job("j3","$HOME/tengine_job_test.sh 0 j3")
  finally do 
    boot_jobs("fj2")
    job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  end
end
