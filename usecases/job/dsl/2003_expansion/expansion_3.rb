# -*- coding: utf-8 -*-
jobnet("u1pj1_jobnet_pattern3", "テスト用ジョブネットパターン3", :vm_instance_name => "u1pj1_localhost", :credential_name => "u1_credential_mm") do
  boot_jobs("jobnet_pt31", "jobnet_pt32")
  jobnet("jobnet_pt31", :to => "jobnet_pt33") do
    auto_sequence
    job("job_pt311", "echo 'success311'")
    job("job_pt312", "echo 'success312'")
  end
  jobnet("jobnet_pt32", :to => "jobnet_pt33") do
    auto_sequence
    job("job_pt321", "echo 'success321'")
    job("job_pt322", "echo 'success322'")
  end
  jobnet("jobnet_pt33") do
    auto_sequence
    job("job_pt331", "echo 'success331'")
    job("job_pt332", "echo 'success332'")
  end
end
