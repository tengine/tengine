# -*- coding: utf-8 -*-

# [jn0004]
#               |-->[j2]-->
#               |         |
# [S1]-->[j1]-->          |-->[j4]-->[E1]
#               |-->[j3]-->
#                     _________finally________
#                    {                        }
#                    {[S2]-->[jn0004_f]-->[E2]}
#                    {________________________}
#                     
jobnet("jn0004", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("j1")
  job("j1", "echo 'j1'", :to => ["j2", "j3"])
  job("j2", "echo 'j2'", :to => "j4")
  job("j3", "echo 'j3'", :to => "j4")
  job("j4", "echo 'j4'")
  finally do
    job("jn0004_f", "echo 'jn0004_f'")
  end
end
