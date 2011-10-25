# -*- coding: utf-8 -*-
jobnet("jobnet1004", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "import_hdfs.sh")
  hadoop_job_run("hadoop_job_run1", "Hadoopジョブ1", "hadoop_job_run.sh") do
    hadoop_job("hadoop_job1")
    hadoop_job("hadoop_job2")
  end
  job("job2", "export_hdfs.sh")
end
