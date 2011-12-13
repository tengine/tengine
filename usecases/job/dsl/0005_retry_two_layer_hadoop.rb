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
  hadoop_job_run("j1", "$HOME/0005_retry_two_layer.sh", :to => ["j2", "jn4"]) do
    hadoop_job("hadoop_job1")
  end
  hadoop_job_run("j2", "$HOME/0005_retry_two_layer.sh", :to => "j4") do 
    hadoop_job("hadoop_job2")
  end
  jobnet("jn4", :to => "j4") do
    boot_jobs("j41")
    hadoop_job_run("j41", "$HOME/0005_retry_two_layer.sh", :to => ["j42", "j43"]) do 
      hadoop_job("hadoop_job41")
    end
    hadoop_job_run("j42", "$HOME/0005_retry_two_layer.sh", :to => "j44") do
      hadoop_job("hadoop_job42")
    end
    hadoop_job_run("j43", "$HOME/0005_retry_two_layer.sh", :to => "j44") do
      hadoop_job("hadoop_job43")
    end
    hadoop_job_run("j44", "$HOME/0005_retry_two_layer.sh") do
      hadoop_job("hadoop_job44")
    end
    finally do
      hadoop_job_run("jn4_f", "$HOME/0005_retry_two_layer.sh") do
        hadoop_job("hadoop_jn4_f")
      end
    end
  end
  hadoop_job_run("j4", "$HOME/0005_retry_two_layer.sh") do 
    hadoop_job("hadoop_job4")
  end
  finally do
    boot_jobs("jn0005_fjn")
    jobnet("jn0005_fjn", :to => "jn0005_f") do
      boot_jobs("jn0005_f1")
      hadoop_job_run("jn0005_f1", "$HOME/0005_retry_two_layer.sh", :to => ["jn0005_f2"]) do
        hadoop_job("hadoop_job1")
      end
      hadoop_job_run("jn0005_f2", "$HOME/0005_retry_two_layer.sh") do
        hadoop_job("hadoop_job1")
      end
      finally do
        hadoop_job_run("jn0005_fif","$HOME/0005_retry_two_layer.sh") do 
          hadoop_job("hadoop_job1")
        end
      end 
    end
    hadoop_job_run("jn0005_f", "$HOME/0005_retry_two_layer.sh") do 
      hadoop_job("hadoop_job1")
    end
  end
end
