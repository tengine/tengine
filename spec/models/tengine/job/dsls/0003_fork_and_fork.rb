# -*- coding: utf-8 -*-

# [jobnet0003]
#                   |--- job2--------------------|
#                   |                            |
# start --- job1 ---F              |--- job4 --- J--- end
#                   |--- job3 ---- F             |
#                                  |--- job5 ----|
jobnet("jobnet0003", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("job1")
  job("job1", "echo 'job1'", :to => ["job2", "job3"])
  job("job2", "echo 'job2'")
  job("job3", "echo 'job3'", :to => ["job4", "job5"])
  job("job4", "echo 'job4'")
  job("job5", "echo 'job5'")
end
