# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("jobnet0017", "ジョブネット0017", :server_name => "i-11111111", :credential_name => "goku-ssh-pk1") do
  auto_sequence
  job("job1", "ジョブ1", "job1.sh")
  job("job2", "ジョブ2", "job2.sh")
  job("job3", "ジョブ3", "job3.sh")
  finally do
    auto_sequence
    job("finally_job1", "finallyジョブ1", "finally_job1.sh")
    job("finally_job2", "finallyジョブ2", "finally_job2.sh")
  end
end
