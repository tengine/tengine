# -*- coding: utf-8 -*-

require 'tengine_job'

# [jobnet0016]
#                                |--- job4 --- job5 ---|
#          |--- job1 --- job3 ---F                     |
# start ---F                     |=== J --- job6 ----- J--- end
#          |--- job2 ------------F                     |
#                                |--------- job7 ------|
jobnet("jobnet0016", :server_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  boot_jobs("job1", "job2")
  job("job1", "echo 'job1'", :to => ["job3"])
  job("job2", "echo 'job2'", :to => ["job6", "job7"])
  job("job3", "echo 'job3'", :to => ["job4", "job6"])
  job("job4", "echo 'job4'", :to => "job5")
  job("job5", "echo 'job5'")
  job("job6", "echo 'job6'")
  job("job7", "echo 'job7'")
end
