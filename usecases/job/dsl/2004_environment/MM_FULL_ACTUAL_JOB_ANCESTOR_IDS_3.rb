# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("grandchild_root", "ネストルートジョブネット3（孫）", :vm_instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  jobnet("jobnet31") do
    auto_sequence
    job("job311", "~/echo_ancestor.sh")
    jobnet("jobnet312") do
      job("job3121", "~/echo_ancestor.sh")
    end
  end
  job("job32", "~/echo_ancestor.sh")
end
