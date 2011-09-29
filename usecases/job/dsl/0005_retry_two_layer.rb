# -*- coding: utf-8 -*-

# [jobnet0005]
#                     ____________________jobnet0004____________________
#                    {                                                  }
#                    {               |--- job0004_2-------              }
#                    {               |                   |              }
# start --- job1 --- { job0004_1 ----                    |--- job0004_4 } ----- end
#                 |  {               |--- job0004_3 ------              }  |
#                 |  { _________________________________________________}  |
#                 L_________________________job2___________________________J

jobnet("jobnet0005", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'", :to => ["job2", "jobnet0004"])
  job("job2", "echo 'job2'", :to => "job4")
  jobnet("jobnet0004", :to => "job4") do
    boot_jobs("job004_1")
    job("job004_1", "echo 'job004_1'", :to => ["job004_2", "job004_3"])
    job("job004_2", "echo 'job004_2'", :to => "job004_4")
    job("job004_3", "echo 'job004_3'", :to => "job004_4")
    job("job004_4", "echo 'job004_4'")
    finally do
      job("jobnet0004_finally", "echo 'jobnet0004_finally'")
    end
  end
  job("job4", "echo 'job4'")
  finally do
    job("jobnet0005_finally", "echo 'jobnet0005_finally'")
  end
end
