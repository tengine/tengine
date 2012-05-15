# -*- coding: utf-8 -*-

require 'tengine_job'

# [jobnet0013]
# start --- job1 --- [hadoop_job_run1] --- job2 --- end
#
# [hadoop_job_run1]
# start --- [hadoop_job1] --- [hadoop_job2] --- end
#
# [hadoop_job1]
#          |--- map ------|
# start ---F              J--- end
#          |--- reduce ---|
#
# [hadoop_job2]
#          |--- map ------|
# start ---F              J--- end
#          |--- reduce ---|
#
jobnet("jobnet0013", "ジョブネット0013", :vm_instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "ジョブ1", "import_hdfs.sh")
  hadoop_job_run("hadoop_job_run1", "Hadoopジョブ1", "hadoop_job_run.sh") do
    hadoop_job("hadoop_job1")
    hadoop_job("hadoop_job2")
  end
  job("job2", "ジョブ2", "export_hdfs.sh")
end
