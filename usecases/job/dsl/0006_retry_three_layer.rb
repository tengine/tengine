# -*- coding: utf-8 -*-
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
jobnet("jn0006", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("jn1")
  jobnet("jn1", :to => "jn2") do
   boot_jobs("j11")
   jobnet("j11", :to => "j12") do
     boot_jobs("j111")
     job("j111", "echo 'job111'",:to => "j112")
     job("j112", "echo 'job112'" )
     finally do
       job("jn11_f","echo 'jn11_f'")
     end
   end
   job("j12", "echo 'job12'")    
   finally do
     job("jn1_f","echo 'jn11_f'")
   end
  end
  jobnet("jn2") do
   boot_jobs("j21")
   job("j21", "echo 'job22'", :to => "j22")    
   jobnet("j22") do
     boot_jobs("j221")
     job("j221", "echo 'job221'",:to => "j222")
     job("j222", "echo 'job222'" )
     finally do
       job("jn22_f","echo 'jn22_f'")
     end
   end
   finally do
     job("jn2_f","echo 'jn2_f'")
   end
  end
  finally do 
    job("jn_f","echo 'jn_f'")
  end
end
