# -*- coding: utf-8 -*-

require 'tengine_job'

# [jobnet0013]
# start --- job1 --- job2 --- job3 --- end
#
jobnet("jobnet0013", "ジョブネット0013", :vm_instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "ジョブ1", "import_hdfs.sh")
  job("job2", "ジョブ2", "hadoop_job_run.sh")
  job("job3", "ジョブ3", "export_hdfs.sh")
end
