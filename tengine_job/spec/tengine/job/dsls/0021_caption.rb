# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("jobnet0021", :caption => "ジョブネット0021", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "ジョブ1", "job1.sh")
  job("job2", "job2.sh", :description => "ジョブ2")
  job("job3", "job3.sh", :caption => "ジョブ3")
  job("job4", "hadoop_job_run4.sh", :caption => "Hadoopジョブ4")
end
