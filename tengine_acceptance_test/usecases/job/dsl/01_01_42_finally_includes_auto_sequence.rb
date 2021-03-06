# -*- coding: utf-8 -*-

require 'tengine_job'

# 1084 Finallyにauto_sequenceを使用する
# [jobnet1084]
#
# [S1]-->[j1]-->[E1]
#                     __________finally___________
#                    {                            }
#                    {[S4]-->[fj1]-->[fj2]-->[E4] }
#                    {____________________________}

jobnet("jobnet1084", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1","$HOME/tengine_job_test.sh 0 j1")
  finally do
    auto_sequence
    job("fj1","$HOME/tengine_job_test.sh 0 fj1")
    job("fj2","$HOME/tengine_job_test.sh 0 fj2")
  end
end
