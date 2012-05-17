# -*- coding: utf-8 -*-

require 'tengine_job'

# finallyを追加する
# [jn0006]
#          __________________________[jn1]____________________________        ______________[jn2]_____________________________________
#         {          __________[jn11]_______________                  }     {                 _____________[jn22]____________         }
#         {         {                               }                 }     {                {                              }         }
#  [S1]-->{ [S2]--> { [S3]-->[j111]-->[j112]-->[E3] } -->[j12]-->[E2] } --> { [S6]-->[j21]-->{ [S7]-->[j221]-->[j222]-->[E7]} -->[E6] } -->[E1]
#         {         {                               }                 }     {                {                              }         }
#         {         {   _______finally_______       }                 }     {                {  _________finally_______     }         }
#         {         {  {[S4]-->[jn11_f]-->[E4]}     }                 }     {                {  {[S8]-->[jn22_f]-->[E8]}    }         }
#         {         {_______________________________}                 }     {                {______________________________}         }
#         {                                                           }     {                                                         }
#         {                                   _______finally_______   }     {                               _______finally_______     }
#         {                                  {[S5]-->[jn1_f]-->[E5]}  }     {                             {[S9]-->[jn2_f]-->[E9]}     }
#         {___________________________________________________________}     {_________________________________________________________}
#
#                                                                                           _______finally_______
#                                                                                          {[S10]-->[jn_f]-->[E10]}
#
jobnet("jn0006_hadoop", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("jn1")
  jobnet("jn1", :to => "jn2") do
   boot_jobs("jn11")
   jobnet("jn11", :to => "j12") do
     boot_jobs("j111")
     hadoop_job_run("j111", "$HOME/0006_retry_three_layer_hadoop.sh",:to => "j112") do
       hadoop_job("hadoop_job111")
     end
     hadoop_job_run("j112", "$HOME/0006_retry_three_layer_hadoop.sh" ) do
       hadoop_job("hadoop_job112")
     end
     finally do
       hadoop_job_run("jn11_f","$HOME/0006_retry_three_layer_hadoop.sh") do
         hadoop_job("hadoop_jn11_f")
       end
     end
   end
   hadoop_job_run("j12", "$HOME/0006_retry_three_layer_hadoop.sh") do
     hadoop_job("hadoop_job12")
   end
   finally do
     hadoop_job_run("jn1_f","$HOME/0006_retry_three_layer_hadoop.sh") do
       hadoop_job("hadoop_jn1_f")
     end
   end
  end
  jobnet("jn2") do
   boot_jobs("j21")
   hadoop_job_run("j21", "$HOME/0006_retry_three_layer_hadoop.sh", :to => "jn22") do
     hadoop_job("hadoop_job21")
   end
   jobnet("jn22") do
     boot_jobs("j221")
     hadoop_job_run("j221", "$HOME/0006_retry_three_layer_hadoop.sh",:to => "j222") do
       hadoop_job("hadoop_job221")
     end
     hadoop_job_run("j222", "$HOME/0006_retry_three_layer_hadoop.sh" ) do
       hadoop_job("hadoop_job222")
     end
     finally do
       hadoop_job_run("jn22_f","$HOME/0006_retry_three_layer_hadoop.sh") do
         hadoop_job("hadoop_job22_f")
       end
     end
   end
   finally do
     hadoop_job_run("jn2_f","$HOME/0006_retry_three_layer_hadoop.sh") do
       hadoop_job("hadoop_jn2_f")
     end
   end
  end
  finally do
    hadoop_job_run("jn_f","$HOME/0006_retry_three_layer_hadoop.sh") do
       hadoop_job("hadoop_jn_f")
     end
  end
end
