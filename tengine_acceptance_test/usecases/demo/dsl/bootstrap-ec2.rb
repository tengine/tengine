require 'tengine_job'
require 'tengine_resource_ec2'

AMI_ID = 'ami-foobar'
AKI_ID = 'aki-foobar'
ARI_ID = 'ari-foobar'
TYPE_ID = 't1.micro'
DC_NAME = 'ap-northeast-1a'
GROUP_IDS = [] # empty -> default

KEY_NAME = 'id_rsa' # the one registered to EC2

jobnet "bootstrap-ec2", instance_name:"localhost", credential_name:"self" do
  auto_sequence

  r = nil
  ruby_job "kick ec2" do
    p = Tengine::ResourceEc2::Provider.first or raise 'no provider'
    i = Tengine::Resource::VirtualServerImage.find_by_provided_id(AMI_ID)
    t = Tengine::Resource::VirtualServerType.find_by_provided_id(TYPE_ID)
    r = p.create_virtual_servers(
     'tengine', i, t, DC_NAME, 'tengine server',
      1, 1, GROUP_IDS, KEY_NAME, '', AKI_ID, ARI_ID)
  end

  ruby_job "wait for instances to boot up" do
    while true do
      # wait for resource watcher to update instance list
      sleep 10
      break false unless r.each do |h|
        v = Tengine::Resource::VirtualServer.find_by_provided_id(h[:aws_instance_id])
        break false if v.state == 'running'
      end
    end
  end
end

# 
# Local Variables:
# mode: ruby
# coding: utf-8-unix
# indent-tabs-mode: nil
# tab-width: 4
# ruby-indent-level: 2
# fill-column: 79
# default-justification: full
# End:
