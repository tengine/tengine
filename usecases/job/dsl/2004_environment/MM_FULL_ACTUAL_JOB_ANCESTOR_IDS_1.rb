# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("child_root1", "ネストルートジョブネット1", :vm_instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  jobnet("jobnet11") do
    auto_sequence
    job("job111", "~/echo_ancestor.sh")
    job("job112", "~/echo_ancestor.sh")
    finally do
      job("job11f", "~/echo_ancestor.sh")
    end
  end
  job("job12", "~/echo_ancestor.sh")
  finally do
    job("job1f", "~/echo_ancestor.sh")
  end
end
