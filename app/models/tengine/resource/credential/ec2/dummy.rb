# -*- coding: utf-8 -*-
# EC2に実際には接続しないであたかも接続しているかのように見せるためのダミーです。
#
# 環境変数EC2_DUMMYがtrueの場合に、RightAws::Ec2の代わりにこのクラスからインスタンスが生成されます。
# 起動してから環境変数EC2_DUMMY_INTERVALで指定された秒数が経過したインスタンス(のダミー)はちゃんとrunningになるようになっています。
#
# [10/08/19 13:06:41] akimatter: モックはtestでしか使えません。
# [10/08/19 13:08:47] akimatter: developmentでは、RightAws::Ec2のインスタンスの代わりのダミー(一般的にはモックって言うけど、specのモックと区別して敢えてダミーします)を使うようにするべきかも。
# [10/08/19 13:09:19] akimatter: ただし、developmentでもダミーではなくEC2にちゃんと繋ぎたい場合もあるので、
# [10/08/19 13:09:41] akimatter: 環境変数か何かの設定でこれらの動作が変わる方が良いかと思います。
class Tengine::Resource::Credential::Ec2::Dummy
  cattr_accessor :last_instance_index
  @@last_instance_index = 0

  # クラス変数で生成しているインスタンスを保持したいところですが、
  # それだとdevelopmentモードでクラスがロードされる度に保持している内容がクリア
  # されてしまうのでNGでした。
  # 他に影響を与えないように実装する手段が他に思いつかなかったので、グローバル変数を使います。
  # cattr_accessor :instances
  # @@instances = {}
  def self.instances
    $ec2_dummy_instances ||= {}
  end
  def self.instances=(value)
    $ec2_dummy_instances = value
  end

  def instances
    self.class.instances
  end

  def initialize(access_key, secret_access_key, options = {})
    @access_key, @secret_access_key = access_key, secret_access_key
    @options = options || {}
  end

  STATIC_ATTRS = {
    :aws_reservation_id=>"r-71a46435",
    :aws_owner=>"000000000888",
    :aws_ramdisk_id=>"ari-c12e7f84",
    :aws_product_codes=>[],
    :monitoring_state=>"disabled",
    :aws_instance_type=>"m1.small",
    :root_device_type=>"instance-store",
    :aws_reason=>"",
    :aws_kernel_id=>"aki-773c6d32",
    :aws_availability_zone=>"us-west-1a"
  }

  def launch_instances(image_id, options)
    launch_time = Time.zone.now
    count = options.delete(:min_count) || 1
    options.delete(:max_count) # :max_countは無視
    idx = 0
    result = []
    count.times do
      instance_index = (self.class.last_instance_index += 1)
      instanceid = "i-DMY%05d" % instance_index
      instance_hash = {
        :aws_instance_id => instanceid,
        :aws_image_id => image_id,
        :state_reason_code=>"pending",
        :ssh_key_name => options[:key_name],
        :aws_groups => options[:group_ids],
        :state_reason_message=>"pending",
        :aws_state_code=>0,
        :dns_name=>"",
        :private_dns_name => "",
        :aws_launch_time => launch_time.iso8601,
        :aws_state => "pending",
        :ami_launch_index => idx.to_s,
      }.update(STATIC_ATTRS.dup)
      idx += 1
      result << instance_hash
      instances[instanceid] = instance_hash
    end
    result
  end

  def describe_instances(instance_ids = [])
    update_instances
    if instance_ids.empty?
      instances.values.sort_by{|hash| hash[:aws_instance_id]}
    else
      instance_ids.map{|id| instances[id]}
    end
  end

  def terminate_instances(instance_ids)
    update_instances
    instance_ids.each do |instance_id|
      update_status_running(instance_id) # 停止する前に一度はrunningにしておく
      hash = instances[instance_id]
      hash.update(
        :state_reason_code=>"Client.UserInitiatedShutdown",
        :state_reason_message=>"Client.UserInitiatedShutdown: User initiated shutdown",
        :aws_state_code=>48,
        :dns_name=>"",
        :private_dns_name=>"",
        :aws_state=>"terminated"
        )
      hash.delete(:ip_address)
      hash.delete(:private_ip_address)
    end
    instance_ids.map do |instance_id|
      {
        :aws_prev_state_name => "running",
        :aws_instance_id => instance_id,
        :aws_current_state_code => 32,
        :aws_current_state_name => "shutting-down",
        :aws_prev_state_code => 16
      }
    end
  end

  private
  UPDATE_INTERVAL = (ENV['EC2_DUMMY_INTERVAL'] || 30).to_i.seconds

  def update_instances
    t = Time.zone.now
    instances.each do |instanceid, hash|
      next unless hash[:aws_state] == "pending"
      launch_time = Time.zone.parse(hash[:aws_launch_time])
      next if (t - launch_time) < UPDATE_INTERVAL
      update_status_running(instanceid)
    end
  end

  def update_status_running(instance_id)
    hash = instances[instance_id]
    unless hash
      raise ArgumentError, "No instance found for #{instance_id.inspect}. " << instances.keys.map(&:to_s).join("\n") << " exist."
    end
    instance_index = hash[:aws_instance_id].sub(/^i\-DMY/, '').to_i
    hash.update(
      :aws_state_code=>16,
      :dns_name=>"ec2-184-72-20-#{instance_index}.us-west-1.compute.amazonaws.com",
      :ip_address=>"184.72.20.#{instance_index}",
      :private_dns_name=>"ip-10-162-153-#{instance_index}.us-west-1.compute.internal",
      :private_ip_address=>"10.162.153.#{instance_index}",
      :aws_state=>"running",
      :architecture=>"i386"
      )
    hash.delete(:state_reason_message)
    hash.delete(:state_reason_code)
  end

end
