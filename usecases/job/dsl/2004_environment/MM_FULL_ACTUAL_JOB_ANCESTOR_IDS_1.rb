# -*- coding: utf-8 -*-
jobnet("child_root1", "ネストルートジョブネット1", :vm_instance_name => "u1pj1_localhost", :credential_name => "u1_credential_mm") do
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
