# -*- coding: utf-8 -*-

# [jobnet0006] ______________jobnet1______________       _______________jobnet2________________
#           {   _______jobnet1_1_____             }     {              _______jobnet2_2_____   }
#           {  {                     }            }     {             {                     }  } 
# start --- {  { job1_1_1 -- job1_1_2} -- job1_2  } --- {  job2_1 --- { job2_2_1 -- job2_2_2}  }
#           {  {_____________________}            }     {             {_____________________}  }
#           {_____________________________________}     {______________________________________}
jobnet("jobnet0006", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("jobnet1")
  jobnet("jobnet1", :to => "jobnet2") do
   boot_jobs("job1_1")
   jobnet("job1_1", :to => "job1_2") do
     boot_jobs("job1_1_1")
     job("job1_1_1", "echo 'job1_1_1'",:to => "job1_1_2")
     job("job1_1_2", "echo 'job1_1_2'" )
   end
   job("job1_2", "echo 'job1_2'")    
  end
  jobnet("jobnet2") do
   boot_jobs("job2_1")
   job("job2_1", "echo 'job2_2'", :to => "job2_2")    
   jobnet("job2_2") do
     boot_jobs("job2_2_1")
     job("job2_2_1", "echo 'job2_2_1'",:to => "job2_2_2")
     job("job2_2_2", "echo 'job2_2_2'" )
   end
  end
end
