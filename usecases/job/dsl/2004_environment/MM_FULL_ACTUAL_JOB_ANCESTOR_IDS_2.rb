# -*- coding: utf-8 -*-
jobnet("child_root2", "ネストルートジョブネット2", :vm_instance_name => "i-centos", :credential_name => "nstore") do
  auto_sequence
  jobnet("jobnet21") do
    auto_sequence
    job("job211", "~/echo_ancestor.sh")
    jobnet("jobnet212") do
      job("job2121", "~/echo_ancestor.sh")
    end
    expansion("grandchild_root")
  end
  job("job22", "~/echo_ancestor.sh")
end
