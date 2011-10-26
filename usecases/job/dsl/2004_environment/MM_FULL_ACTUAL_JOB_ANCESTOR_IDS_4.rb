
require 'tengine_job'

jobnet("expansion_jobnet_99_4_1", :vm_instance_name => "test_server1", :credential_name => "test_credential1") do
  auto_sequence
  expansion("child_root1")
  expansion("child_root2")
  job("job33", "~/echo_ancestor.sh")
end
