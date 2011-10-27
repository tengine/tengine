# -*- coding: utf-8 -*-

require 'tengine_job'

# [jn0005]
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
#  {         _____________________jn0005_fjn__________                     }
#  {        {                                         }                    }
#  {        { [S5]-->[jn0005_f1]-->[jn0005_f2]-->[E5] }                    }
#  { [S4]-->{                                         }-->[jn0005_f]-->[E4]}
#  {        {      ____________finally________        }                    }
#  {        {      {[S6]-->[jn0005_fif]-->[E6]}       }                    }
#  {        {_________________________________________}                    }
#  { ______________________________________________________________________}

jobnet("jn0005", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1", "echo 'job1'", :to => ["j2", "jn4"])
  job("j2", "echo 'job2'", :to => "j4")
  jobnet("jn4", :to => "j4") do
    boot_jobs("j41")
    job("j41", "echo 'job41'", :to => ["j42", "j43"])
    job("j42", "echo 'job42'", :to => "j44")
    job("j43", "echo 'job43'", :to => "j44")
    job("j44", "echo 'job44'")
    finally do
      job("jn4_f", "echo 'jn4_f'")
    end
  end
  job("j4", "echo 'j4'")
  finally do
    boot_jobs("jn0005_fjn")
    jobnet("jn0005_fjn", :to => "jn0005_f") do
      boot_jobs("jn0005_f1")
      job("jn0005_f1", "echo jn0005_f1", :to => ["jn0005_f2"])
      job("jn0005_f2", "echo jn0005_f2")
      finally do
        job("jn0005_fif","echo 'jn0005_fif'")
      end 
    end
    job("jn0005_f", "echo 'jobnet0005_finally'")
  end
end
