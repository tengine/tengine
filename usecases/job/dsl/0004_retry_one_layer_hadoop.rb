# -*- coding: utf-8 -*-

require 'tengine_job'

# [jn0004]
#               |-->[j2]-->
#               |         |
# [S1]-->[j1]-->          |-->[j4]-->[E1]
#               |-->[j3]-->
#                     _________finally________
#                    {                        }
#                    {[S2]-->[jn0004_f]-->[E2]}
#                    {________________________}
#
jobnet("jn0004_hadoop", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  hadoop_job_run("j1", "$HOME/0004_retry_one_layer.sh", :to => ["j2", "j3"]) do
    hadoop_job("hadoop_job1")
  end
  hadoop_job_run("j2", "$HOME/0004_retry_one_layer.sh", :to => "j4") do
    hadoop_job("hadoop_job2")
  end
  hadoop_job_run("j3", "$HOME/0004_retry_one_layer.sh", :to => "j4") do
    hadoop_job("hadoop_job3")
  end
  hadoop_job_run("j4", "$HOME/0004_retry_one_layer.sh") do
    hadoop_job("hadoop_job4")
  end
  finally do
     hadoop_job_run("jn0004_f", "$HOME/0004_retry_one_layer.sh") do
       hadoop_job("finally")
     end
  end
end
