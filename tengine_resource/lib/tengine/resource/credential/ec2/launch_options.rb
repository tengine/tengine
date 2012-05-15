# -*- coding: utf-8 -*-
class Tengine::Resource::Credential::Ec2::LaunchOptions

  def initialize(credential)
    @credential = credential
  end

  LAUNCH_OPTIONS_KEYS = %w(current_region regions availability_zones key_pairs
    security_groups images instance_types kernel_ids ramdisk_ids)

  def launch_options(connection, current_region)
    @connection, @current_region = connection, current_region
    LAUNCH_OPTIONS_KEYS.inject({}){|dest, m| dest[m] = send(m); dest}
  ensure
    @connection, @current_region = nil, nil
  end

  attr_reader :current_region

  DEFAULT_REGION_CAPTIONS = {
    "us-east-1"      => "US East" ,
    "us-west-1"      => "US West" ,
    "eu-west-1"      => "EU West" ,
    "ap-southeast-1" => "Asia Pacific"
  }.freeze

  def regions
    # ["eu-west-1", "us-east-1", "us-west-1", "ap-southeast-1"]
    raw = @connection.describe_regions
    raw.inject([]) do |dest, region|
      dest << {"name" => region, "caption" => DEFAULT_REGION_CAPTIONS[region]}
    end
  end

  def availability_zones
    # [
    #   {:region_name=>"us-east-1", :zone_name=>"us-east-1a", :zone_state=>"available"},
    #   {:region_name=>"us-east-1", :zone_name=>"us-east-1b", :zone_state=>"available"},
    #   {:region_name=>"us-east-1", :zone_name=>"us-east-1c", :zone_state=>"available"},
    #   {:region_name=>"us-east-1", :zone_name=>"us-east-1d", :zone_state=>"available"}
    # ]
    raw = @connection.describe_availability_zones
    raw.map{|h| h[:zone_name]}.sort
  end

  def key_pairs
    # [{:aws_key_name=>"west-dev01", :aws_fingerprint=>"7c:89:2f:c9:4a:1c:02:65:1b:14:dc:a5:c9:a0:da:fb:46:08:4a:99"}]
    raw = @connection.describe_key_pairs
    raw.map{|h| h[:aws_key_name]}
  end

  def security_groups
    # [
    #   { :aws_owner=>"892601002221", :aws_group_name=>"default", :aws_description=>"default group",
    #     :aws_perms=>[{:owner=>"892601002221", :group=>"default"}, {:from_port=>"22", :to_port=>"22", :cidr_ips=>"0.0.0.0/0", :protocol=>"tcp"}]},
    #   { :aws_owner=>"892601002221", :aws_group_name=>"ruby-dev", :aws_description=>"for developmewnt with ruby",
    #     :aws_perms=>[{:from_port=>"80", :to_port=>"80", :cidr_ips=>"0.0.0.0/0", :protocol=>"tcp"}]}
    # ]
    raw = @connection.describe_security_groups
    raw.map{|h| h[:aws_group_name]}
  end

  def images
    # [
    #   {
    #     :aws_id=>"ami-5189d814",
    #     :aws_architecture=>"i386", :root_device_type=>"instance-store",
    #     :root_device_name=>"/dev/sda1",
    #     :aws_location=>"akm2000-us-west-2/dev-20100521-01.manifest.xml",
    #     :aws_image_type=>"machine", :aws_state=>"available",
    #     :aws_owner=>"892601002221", :aws_is_public=>false,
    #     :aws_kernel_id=>"aki-773c6d32", :aws_ramdisk_id=>"ari-c12e7f84",
    #   },
    # ]
    saved_images = Tengine::Resource::VirtualServerImage.all
    # raw_images = @connection.describe_images_by_owner('self')
    raw_images = @connection.describe_images(saved_images.map(&:provided_id).uniq.compact) #クラスタに登録されているAMI
    # raw_images += @connection.describe_images_by_executable_by("self") # 実行可能なAMI
    amiid_to_hash = raw_images.inject({}){|d, hash| d[hash[:aws_id]] = hash; d}
    result = saved_images.map do |saved_image|
      if ami = amiid_to_hash[saved_image.provided_id]
        {
          'id' => saved_image.id,
          'name' => ami[:aws_id],
          'caption' => saved_image.description,
          'aws_architecture' => ami[:aws_architecture],
          'aws_arch_root_dev' => to_aws_arch_root_dev(ami),
        }
      else
        nil
      end
    end
    result.compact.uniq
  end

  def instance_types
    # rawなし
    INSTANCE_TYPES
  end

  def kernel_ids
    # [
    #   {
    #     :aws_id=>"aki-233c6d66",
    #     :aws_architecture=>"i386", :root_device_type=>"instance-store",
    #     :aws_location=>"ec2-paid-ibm-images-us-west-1/vmlinuz-2.6.16.60-0.29-xenpae.i386.manifest.xml",
    #     :aws_image_type=>"kernel", :aws_state=>"available", :aws_owner=>"470254534024",
    #     :aws_is_public=>true, :image_owner_alias=>"amazon",
    #   },
    # ]
    raw = amazon_images.select{|img| img[:aws_image_type] == 'kernel'}
    raw.inject({}) do |dest, hash|
      key = hash[:aws_architecture]
      dest[key] ||= []
      dest[key] << hash[:aws_id]
      dest
    end
  end

  def ramdisk_ids
    # [
    #   {
    #     :aws_id=>"ari-2d3c6d68",
    #     :aws_architecture=>"i386", :root_device_type=>"instance-store",
    #     :aws_location=>"ec2-paid-ibm-images-us-west-1/initrd-2.6.16.60-0.29-xenpae.i386.manifest.xml",
    #     :aws_image_type=>"ramdisk", :aws_state=>"available", :aws_owner=>"470254534024",
    #     :aws_is_public=>true, :image_owner_alias=>"amazon"
    #   },
    # ]
    raw = amazon_images.select{|img| img[:aws_image_type] == 'ramdisk'}
    raw.inject({}) do |dest, hash|
      key = hash[:aws_architecture]
      dest[key] ||= []
      dest[key] << hash[:aws_id]
      dest
    end
  end

  private

  def amazon_images
    @amazon_images ||= @connection.describe_images_by_owner('amazon')
  end


  def to_aws_arch_root_dev(hash)
    "#{hash[:aws_architecture]}_#{hash[:root_device_type]}"
  end

  INSTANCE_TYPES = {
    'i386_instance-store' => [
      { "value" => "m1.small"  , "caption" => "Small" },
      { "value" => "c1.medium" , "caption" => "High-CPU Medium" },
    ].freeze,
    'i386_ebs' => [
      { "value" => "t1.micro"  , "caption" => "Micro" },
      { "value" => "m1.small"  , "caption" => "Small" },
      { "value" => "c1.medium" , "caption" => "High-CPU Medium" },
    ].freeze,
    'x86_64_instance-store' => [
      { "value" => "m1.large"  , "caption" => "Large" },
      { "value" => "m1.xlarge" , "caption" => "Extra Large" },
      { "value" => "m2.xlarge" , "caption" => "High-Memory Extra Large" },
      { "value" => "m2.2xlarge", "caption" => "High-Memory Double Extra Large" },
      { "value" => "m2.4xlarge", "caption" => "High-Memory Quadruple Extra Large" },
      { "value" => "c1.xlarge" , "caption" => "High-CPU Extra Large" },
    ].freeze,
    'x86_64_ebs' => [
      { "value" => "t1.micro"  , "caption" => "Micro" },
      { "value" => "m1.large"  , "caption" => "Large" },
      { "value" => "m1.xlarge" , "caption" => "Extra Large" },
      { "value" => "m2.xlarge" , "caption" => "High-Memory Extra Large" },
      { "value" => "m2.2xlarge", "caption" => "High-Memory Double Extra Large" },
      { "value" => "m2.4xlarge", "caption" => "High-Memory Quadruple Extra Large" },
      { "value" => "c1.xlarge" , "caption" => "High-CPU Extra Large" },
    ].freeze,
  }.freeze

end
