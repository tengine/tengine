
require 'tengine_job'

jobnet("jobnet1021", :instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  job("job1", "import_hdfs.sh")
  hadoop_job_run("hadoop_job_run1", "hadoop_job_run.sh") do
    hadoop_job("hadoop_job1")
    hadoop_job("hadoop_job2")
    job("job2", "$HOME/tengine_job_test.sh 0 job2")
  end
  job("job3", "export_hdfs.sh")
end
