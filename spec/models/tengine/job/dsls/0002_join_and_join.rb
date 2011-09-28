# -*- coding: utf-8 -*-

# [jobnet0002]
#          |--- job1 ---|
#          |            J--- job4 ---|
# start ---F--- job2 ---|            |
#          |                         J--- job5 --- end
#          |--- job3 ----------------|
#
jobnet("jobnet0002", :instance_name => "i-11111111", :user_group_credential_name => "goku-ssh-pk1") do
  boot_jobs("job1", "job2", "job3")
  job("job1", "echo 'job1'", :to => "job4")
  job("job2", "echo 'job2'", :to => "job4")
  job("job3", "echo 'job3'", :to => "job5")
  job("job4", "echo 'job4'", :to => "job5")
  job("job5", "echo 'job5'")
end
