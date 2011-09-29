# -*- coding: utf-8 -*-

# [jobnet0004]
#                   |--- job2-------
#                   |              |
# start --- job1 ----              |--- job4 ----- end
#                   |--- job3 ------
# 
jobnet("jobnet0004", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'", :to => ["job2", "job3"])
  job("job2", "echo 'job2'", :to => "job4")
  job("job3", "echo 'job3'", :to => "job4")
  job("job4", "echo 'job4'")
  finally do
    job("jobnet0004_finally", "echo 'jobnet0004_finally'")
  end
end
