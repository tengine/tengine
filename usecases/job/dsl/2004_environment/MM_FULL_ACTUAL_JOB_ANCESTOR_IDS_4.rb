jobnet("expansion_jobnet_99_4_1", :vm_instance_name => "u1pj1_localhost", :credential_name => "u1_credential_mm") do
  auto_sequence
  expansion("child_root1")
  expansion("child_root2")
  job("job33", "~/echo_ancestor.sh")
end
