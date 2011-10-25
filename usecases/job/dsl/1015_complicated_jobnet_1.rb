# -*- coding: utf-8 -*-

require 'tengine_job'

# c.f -> http://bts.tenginefw.com/trac/monkey-magic/wiki/0.9.6/function_test_additional_scenario
#
jobnet('complicated_jobnet', '複雑なジョブネット', :vm_instance_name => "test_server1",:credential_name => "test_credential1") do  
boot_jobs("i_jobnet1-1", "i_jobnet1-2", "i_jobnet1-3", "i_jobnet2-1", "i_jobnet2-2")  
  jobnet('i_jobnet1-1', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
      auto_sequence
      job("i_jobnet1-1-0", "echo 'jobnet1-1 START'")
      job("i_jobnet1-1-1", "sleep 5")
      job("i_jobnet1-1-2", "echo 'jobnet1-1 END'")
  end
  jobnet('i_jobnet1-2',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
      auto_sequence
      job("i_jobnet1-2-0", "echo 'jobnet1-2 START'")
      job("i_jobnet1-2-1", "sleep 10")
      job("i_jobnet1-2-2", "echo 'jobnet1-2 END'")
  end
  jobnet('i_jobnet1-3', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
      boot_jobs("i_job1-1","i_job1-2","i_job1-3","i_job2-1","i_job2-2")
      job("i_job1-1", "sleep 1",:to => "i_job3")
      job("i_job1-2", "sleep 1",:to => "i_job3")
      job("i_job1-3", "sleep 1",:to => "i_job3")
      job("i_job2-1", "sleeeeeep 1",:to => "i_job2-0")
      job("i_job2-2", "sleep 1",:to => "i_job2-0")
      job("i_job2-0", "sleep 1",:to => "i_job3")
      job("i_job3", "sleep 1")
  end
  jobnet('i_jobnet2-1',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet2-0") do   
      auto_sequence
      job("i_jobnet2-1-0", "echo 'jobnet2-1 START'")
      job("i_jobnet2-1-1", "sleep 1")
      job("i_jobnet2-1-2", "echo 'jobnet2-1 END'")
  end
  jobnet('i_jobnet2-2', :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet2-0") do    
      auto_sequence
      job("i_jobnet2-2-0", "echo 'jobnet2-2 START'")
      job("i_jobnet2-2-1", "sleep 1")
      job("i_jobnet2-2-2", "echo 'jobnet2-2 END'")
  end
  jobnet('i_jobnet2-0',  :vm_instance_name => "test_server1",:credential_name => "test_credential1",:to => "i_jobnet3") do
      auto_sequence
      job("i_jobnet2-0-0", "echo 'jobnet2-0 START'")
      job("i_jobnet2-0-1", "sleep 1")
      job("i_jobnet2-0-2", "echo 'jobnet2-0 END'")
  end
  jobnet('i_jobnet3',  :vm_instance_name => "test_server1",:credential_name => "test_credential1") do
      auto_sequence
      job("i_jobnet3-0", "echo 'jobnet3 START'")
      job("i_jobnet3-1", "sleep 1")
      job("i_jobnet3-2", "echo 'jobnet3 END'")
  end
end
