jobnet("jobnet1036", :instance_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "import_hdfs.sh")
  hadoop_job_run("hadoop_job_run1","hadoop_job_run.sh", :hoge => "hoge") do
    hadoop_job("hadoop_job1")
    hadoop_job("hadoop_job2")
  end
  job("job2", "export_hdfs.sh")
end
