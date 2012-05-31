# -*- coding: utf-8 -*-

require 'tengine_job'

# c.f -> http://bts.tenginefw.com/trac/monkey-magic/wiki/0.9.6/function_test_additional_scenario
#
jobnet('complicated_jobnet', '複雑なジョブネット', :vm_instance_name => "test_server1",:credential_name => "test_credential1") do  
boot_jobs("i_jobnet1-1", "i_jobnet1-2", "i_jobnet1-3", "i_jobnet2-1", "i_jobnet2-2")  
  jobnet('i_jobnet1-1', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
      auto_sequence
      job("i_jobnet1-1", "$HOME/tengine_job_test.sh 5 jobnet1-1")
  end
  jobnet('i_jobnet1-2',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
      auto_sequence
      job("i_jobnet1-2", "$HOME/tengine_job_test.sh 10 jobnet1-2")
  end
  jobnet('i_jobnet1-3', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
      boot_jobs("i_job1-1","i_job1-2","i_job1-3","i_job2-1","i_job2-2")
      job("i_job1-1", "$HOME/tengine_job_test.sh 1 job1-1",:to => "i_job3")
      job("i_job1-2", "$HOME/tengine_job_test.sh 1 job1-2",:to => "i_job3")
      job("i_job1-3", "$HOME/tengine_job_test.sh 1 job1-3",:to => "i_job3")
      job("i_job2-1", "$HOME/tengine_job_failure_test.sh 1 job2-1",:to => "i_job2-0")
      job("i_job2-2", "$HOME/tengine_job_test.sh 1 job2-2",:to => "i_job2-0")
      job("i_job2-0", "$HOME/tengine_job_test.sh 1 job2-0",:to => "i_job3")
      job("i_job3", "$HOME/tengine_job_test.sh 1 job3")
  end
  jobnet('i_jobnet2-1',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet2-0") do   
      auto_sequence
      job("i_jobnet2-1", "$HOME/tengine_job_test.sh 1 jobnet2-1")
  end
  jobnet('i_jobnet2-2', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet2-0") do    
      auto_sequence
      job("i_jobnet2-2", "$HOME/tengine_job_test.sh 1 jobnet2-2")
  end
  jobnet('i_jobnet2-0',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
      auto_sequence
      job("i_jobnet2-0", "$HOME/tengine_job_test.sh 1 jobnet2-0")
  end
  jobnet('i_jobnet3',  :vm_instance_name => "test_server1",:credential_name => "test_credential1") do
      auto_sequence
      job("i_jobnet3", "$HOME/tengine_job_test.sh 1 jobnet3")
  end
end
