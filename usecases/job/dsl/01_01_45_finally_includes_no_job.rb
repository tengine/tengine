# -*- coding: utf-8 -*-

require 'tengine_job'

# 1090 Finallyにブロック内にコードがない
# [jobnet1090]
#
# [S1]-->[j1]-->[E1]
#                     __________finally___________
#                    {                            }
#                    {____________________________}

jobnet("jobnet1090", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1","$HOME/tengine_job_test.sh 0 j1")
  finally do
  end
end
