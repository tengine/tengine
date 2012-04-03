# -*- coding: utf-8 -*-

require 'tengine_job'

# 1088 Finallyにjobのoptionに不正な値
# [jobnet1088]
#
# [S1]-->[j1]-->[E1]
#                     __________finally___________
#                    {                            }
#                    {       |-->[fj1]-->|        }
#                    {       |           |        }
#                    {[S4]-->F           J-->[E4] }
#                    {       |           |        }
#                    {       |-->[fj2]-->|        }
#                    {____________________________}

jobnet("jobnet1088", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1","$HOME/tengine_job_test.sh 0 j1")
  finally do
    boot_jobs("fj1","fj2")
    job("fj1","$HOME/tengine_job_test.sh 0 fj1", :hoge => "hoge")
    job("fj2","$HOME/tengine_job_test.sh 0 fj2", :fuga => "fuga")
  end
end
