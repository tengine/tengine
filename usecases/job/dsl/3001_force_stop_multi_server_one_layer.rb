# -*- coding: utf-8 -*-

require 'tengine_job'

# [jn3001]
#               |-->[j2]-->
#               |         |
# [S1]-->[j1]-->          |-->[j4]-->[E1]
#               |-->[j3]-->
#                     _________finally________
#                    {                        }
#                    {[S2]-->[jn3001_f]-->[E2]}
#                    {________________________}
#                     
jobnet("jn3001", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1", "$HOME/3001_force_stop_multi_server_one_layer.sh", :instance_name => "test_server1", :to => ["j2", "j3"])
  job("j2", "$HOME/3001_force_stop_multi_server_one_layer.sh", :instance_name => "test_server2", :credential_name => "test_credential2", :to => "j4")
  job("j3", "$HOME/3001_force_stop_multi_server_one_layer.sh", :instance_name => "test_server3", :credential_name => "test_credential3", :to => "j4")
  job("j4", "$HOME/3001_force_stop_multi_server_one_layer.sh", :credential_name => "test_credential1")
  finally do
    job("jn3001_f", "$HOME/3001_force_stop_multi_server_one_layer.sh", :credential_name => "test_credential1")
  end
end
