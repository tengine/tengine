# -*- coding: utf-8 -*-

require 'tengine_job'

# [jn3002]
#                     ________________[jn4]________________
#                   {                                          }
#                   {               |-->[j42]-->               }
#                   {               |          |               }
# [S1]-->[j1]-->F-->{ [S2]-->[j41]-->          |-->[j44]-->[E2]}-->J--[j4]-->[E1]
#               |   {               |-->[j43]-->               }   |
#               |   {         __________finally__________      }   |
#               |   {        { [S3]-->[jn4_f]-->[E3] }     }   |
#               |   { _________________________________________}   |
#               |-------------------->[j2]------------------------>|
#
#   ________________________________finally________________________________
#  {         _____________________jn3002_fjn__________                     }
#  {        {                                         }                    }
#  {        { [S5]-->[jn3002_f1]-->[jn3002_f2]-->[E5] }                    }
#  { [S4]-->{                                         }-->[jn3002_f]-->[E4]}
#  {        {      ____________finally________        }                    }
#  {        {      {[S6]-->[jn3002_fif]-->[E6]}       }                    }
#  {        {_________________________________________}                    }
#  { ______________________________________________________________________}

jobnet("jn3002", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1", "$HOME/3002_force_stop_multi_server_two_layer.sh", :to => ["j2", "jn4"])
  job("j2", "$HOME/3002_force_stop_multi_server_two_layer.sh", :instance_name => "test_server2", :credential_name => "test_credential2", :to => "j4")
  jobnet("jn4", :instance_name => "test_server3", :credential_name => "test_credential2", :to => "j4") do
    boot_jobs("j41")
    job("j41", "$HOME/3002_force_stop_multi_server_two_layer.sh", :instance_name => "test_server1", :credential_name => "test_credential1", :to => ["j42", "j43"])
    job("j42", "$HOME/3002_force_stop_multi_server_two_layer.sh", :instance_name => "test_server2", :to => "j44")
    job("j43", "$HOME/3002_force_stop_multi_server_two_layer.sh", :credential_name => "test_credential3", :to => "j44")
    job("j44", "$HOME/3002_force_stop_multi_server_two_layer.sh", :credential_name => "test_credential3")
    finally do
      job("jn4_f", "$HOME/3002_force_stop_multi_server_two_layer.sh", :instance_name => "test_server2")
    end
  end
  job("j4", "$HOME/3002_force_stop_multi_server_two_layer.sh")
  finally do
    boot_jobs("jn3002_fjn")
    jobnet("jn3002_fjn", :to => "jn3002_f") do
      boot_jobs("jn3002_f1")
      job("jn3002_f1", "$HOME/3002_force_stop_multi_server_two_layer.sh", :to => ["jn3002_f2"])
      job("jn3002_f2", "$HOME/3002_force_stop_multi_server_two_layer.sh", :instance_name => "test_server2", :credential_name => "test_credential2")
      finally do
        job("jn3002_fif","$HOME/3002_force_stop_multi_server_two_layer.sh", :instance_name => "test_server3", :credential_name => "test_credential3")
      end 
    end
    job("jn3002_f", "$HOME/3002_force_stop_multi_server_two_layer.sh")
  end
end
