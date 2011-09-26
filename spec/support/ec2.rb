# -*- coding: utf-8 -*-
def setup_ec2_images
  klass = Tengine::Resource::VirtualServerImage
  result = [
    # us-west-1
    klass.create!(:name => "ami-10101010mysql", :provided_name => "ami-10101000", :description => "MySQL server"),     # *1 同じAMI ID
    klass.create!(:name => "ami-10101010rails", :provided_name => "ami-10101000", :description => "Rails App Server"), # *1 同じAMI ID
    klass.create!(:name => "ami-10102000"     , :provided_name => "ami-10102000", :description => "Nginx Server"),
    # us-west-2
    klass.create!(:name => "ami-10103000"     , :provided_name => "ami-10103000", :description => "APP1 servers"),
    klass.create!(:name => "ami-10104000"     , :provided_name => "ami-10104000", :description => "APP2 servers"),
  ]
end


def setup_ec2_stub(images = setup_ec2_images)
  mock_ec2 = mock(:ec2)
  mock_ec2.stub!(:describe_regions).and_return([
      "eu-west-1", "us-east-1", "us-west-1", "ap-southeast-1"
    ])
  mock_ec2.stub!(:describe_availability_zones).and_return([
      {:region_name=>"us-west-1", :zone_name=>"us-west-1a", :zone_state=>"available"},
      {:region_name=>"us-west-1", :zone_name=>"us-west-1b", :zone_state=>"available"},
    ])
  mock_ec2.stub!(:describe_key_pairs).and_return([
      {:aws_key_name=>"goku"   , :aws_fingerprint=>"7c:89:2f:c9:4a:1c:02:65:1b:14:dc:a5:c9:a0:da:fb:46:08:4a:97"},
      {:aws_key_name=>"dev"    , :aws_fingerprint=>"7c:89:2f:c9:4a:1c:02:65:1b:14:dc:a5:c9:a0:da:fb:46:08:4a:98"},
      {:aws_key_name=>"default", :aws_fingerprint=>"7c:89:2f:c9:4a:1c:02:65:1b:14:dc:a5:c9:a0:da:fb:46:08:4a:99"},
    ])
  mock_ec2.stub!(:describe_security_groups).and_return([
      { :aws_owner=>"892601002221", :aws_group_name=>"default", :aws_description=>"default group",
        :aws_perms=>[{:owner=>"892601002221", :group=>"default"}, {:from_port=>"22", :to_port=>"22", :cidr_ips=>"0.0.0.0/0", :protocol=>"tcp"}]},
      { :aws_owner=>"892601002221", :aws_group_name=>"hadoop-dev", :aws_description=>"for developmewnt with hadoop",
        :aws_perms=>[{:from_port=>"80", :to_port=>"80", :cidr_ips=>"0.0.0.0/0", :protocol=>"tcp"}]},
      { :aws_owner=>"892601002221", :aws_group_name=>"ruby-dev", :aws_description=>"for developmewnt with ruby",
        :aws_perms=>[{:from_port=>"80", :to_port=>"80", :cidr_ips=>"0.0.0.0/0", :protocol=>"tcp"}]},
    ])
  mock_ec2.stub!(:describe_images).
    with(images.map(&:provided_name).uniq).
    and_return([
      {
        :aws_id=>images[0].provided_name, # "ami-012b7a44",
        :aws_architecture=>"i386", :root_device_type=>"instance-store",
        :aws_kernel_id=>"aki-f70657b2", :aws_ramdisk_id=>"ari-ff0657ba",
        :root_device_name=>"/dev/sda5",
        :aws_location=>"zeus-technology-us-west-1/zeus-load-balancer-60r2-v2-100tps-100mbps-32bit.manifest.xml",
        :aws_image_type=>"machine", :aws_state=>"available",
        :aws_owner=>"106430830294", :aws_is_public=>true,
        :aws_product_codes=>["F6F58AC9"]
      },
      {
        :aws_id=>images[2].provided_name, # "ami-05530240",
        :aws_architecture=>"x86_64", :root_device_type=>"ebs",
        :aws_kernel_id=>"aki-6f3c6d2a", :aws_ramdisk_id=>"ari-693c6d2c",
        :root_device_name=>"/dev/sda1",
        :aws_location=>"063491364108/ubuntu-8.04.3-hardy-server-amd64-20091130",
        :aws_image_type=>"machine",
        :description=>"Ubuntu 8.04.3 Hardy server amd64 20091130", :aws_state=>"available",
        :aws_owner=>"063491364108", :aws_is_public=>true,
        :block_device_mappings=>[{:ebs_volume_size=>15, :ebs_delete_on_termination=>true, :device_name=>"/dev/sda1", :ebs_snapshot_id=>"snap-ea54fb82"}],
        :name=>"ubuntu-8.04.3-hardy-server-amd64-20091130"
      }
    ])

  mock_ec2.stub!(:describe_images_by_owner).with("amazon").and_return([
      # kernels = conn.describe_images_by_owner('amazon').select{|i| i[:aws_image_type] == "kernel"}
      # kernels.select{|k| h[:aws_architecture] == "i386"} の中から抜粋
      {:root_device_type=>"instance-store", :aws_location=>"ec2-paid-ibm-images-us-west-1/vmlinuz-2.6.16.60-0.29-xenpae.i386.manifest.xml", :aws_image_type=>"kernel", :aws_state=>"available", :aws_owner=>"470254534024", :aws_is_public=>true, :image_owner_alias=>"amazon", :aws_id=>"aki-00000000", :aws_architecture=>"i386"},
      {:root_device_type=>"instance-store", :aws_location=>"ec2-paid-ibm-images-us-west-1/vmlinuz-2.6.16.60-0.29-xenpae.i386.manifest.xml", :aws_image_type=>"kernel", :aws_state=>"available", :aws_owner=>"470254534024", :aws_is_public=>true, :image_owner_alias=>"amazon", :aws_id=>"aki-11111111", :aws_architecture=>"i386"},
      # kernels.select{|k| h[:aws_architecture] == "x86_64"} の中から抜粋
      {:root_device_type=>"instance-store", :aws_location=>"ec2-public-images-us-west-1/ec2-vmlinuz-2.6.21.7-2.fc8xen.x86_64.manifest.xml", :aws_image_type=>"kernel", :aws_state=>"available", :aws_owner=>"206029621532", :aws_is_public=>true, :image_owner_alias=>"amazon", :aws_id=>"aki-22222222", :aws_architecture=>"x86_64"},
      {:root_device_type=>"instance-store", :aws_location=>"ec2-public-images-us-west-1/pv-grub-hd0-V1.01-x86_64.gz.manifest.xml"         , :aws_image_type=>"kernel", :aws_state=>"available", :aws_owner=>"206029621532", :aws_is_public=>true, :image_owner_alias=>"amazon", :aws_id=>"aki-33333333", :aws_architecture=>"x86_64"},

      # ramdisks = conn.describe_images_by_owner('amazon').select{|i| i[:aws_image_type] == "ramdisk"}
      # ramdisks.select{|k| h[:aws_architecture] == "i386"} の中から抜粋
      {:root_device_type=>"instance-store", :aws_location=>"ec2-paid-ibm-images-us-west-1/initrd-2.6.16.60-0.29-xenpae.i386.manifest.xml", :aws_image_type=>"ramdisk", :aws_state=>"available", :aws_owner=>"470254534024", :aws_is_public=>true, :image_owner_alias=>"amazon", :aws_id=>"ari-00000000", :aws_architecture=>"i386"},
      {:root_device_type=>"instance-store", :aws_location=>"ec2-paid-ibm-images-us-west-1/initrd-2.6.16.60-0.29-xenpae.i386.manifest.xml", :aws_image_type=>"ramdisk", :aws_state=>"available", :aws_owner=>"470254534024", :aws_is_public=>true, :image_owner_alias=>"amazon", :aws_id=>"ari-11111111", :aws_architecture=>"i386"},
      # ramdisks.select{|k| h[:aws_architecture] == "x86_64"} の中から抜粋
      {:root_device_type=>"instance-store", :aws_location=>"ec2-public-images-us-west-1/ec2-initrd-2.6.21.7-2.fc8xen.x86_64.manifest.xml"                       , :aws_image_type=>"ramdisk", :aws_state=>"available", :aws_owner=>"206029621532", :aws_is_public=>true, :image_owner_alias=>"amazon", :aws_id=>"ari-22222222", :aws_architecture=>"x86_64"},
      {:root_device_type=>"instance-store", :aws_location=>"ec2-public-images-us-west-1/initrd-2.6.21.7-2.ec2.v1.1.fc8xen-x86_64-lvm-rootVG-rootFS.manifest.xml", :aws_image_type=>"ramdisk", :aws_state=>"available", :aws_owner=>"206029621532", :aws_is_public=>true, :name=>"initrd-2.6.21.7-2.ec2.v1.1.fc8xen-x86_64-lvm-rootVG-rootFS", :image_owner_alias=>"amazon", :aws_id=>"ari-33333333", :aws_architecture=>"x86_64"},
    ])
  mock_ec2
end
