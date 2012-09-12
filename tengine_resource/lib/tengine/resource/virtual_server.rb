# -*- coding: utf-8 -*-
class Tengine::Resource::VirtualServer < Tengine::Resource::Server
  field :provided_image_id, :type => String
  field :provided_type_id, :type => String

  belongs_to :host_server, :inverse_of => :guest_servers, :index => true,
    :class_name => "Tengine::Resource::Server"
  belongs_to :provider, :index => true, :inverse_of => :virtual_servers,
    :class_name => "Tengine::Resource::Provider"

  validates_uniqueness_of :provided_id, :scope => :provider_id, :unless => :ignore_provided_id_uniqueness
  index({ provided_id: 1, provider_id: 1 }, { unique: true })

  ## launch_modeに関する実装

  class LaunchValidator < ActiveModel::Validator
    def validate(record)
      base_attrs = record.attributes.dup.freeze
      error_names = []
      (1..record.launch_count).each do |idx|
        # see also Tengine::Resource::Provider::Ec2#create_virtual_servers
        name = sprintf("%s%03d", record.name, idx) # 1 origin
        server = Tengine::Resource::VirtualServer.new(base_attrs.merge(
            :ignore_provided_id_uniqueness => true,
            :name => name
            ))
        next if server.valid?
        server.errors.each do |key, msg|
          if key == :name
            error_names << server.name
          else
            record.errors.add(key, msg)
          end
        end
      end
      unless error_names.empty?
        # record.name = error_names.join(",")
        # record.errors.add(:name, :taken)
        record.errors.add(:name, "に指定された%sは既に登録されています" % error_names.join(","))
      end
    end
  end

  validates_with LaunchValidator, :if => Proc.new{|r| r.launch_mode?}

  attr_accessor :ignore_provided_id_uniqueness

  attr_reader :launch_count
  attr_reader :launch_count_max
  def launch_count=(val); @launch_count = val ? val.to_i : nil; end
  def launch_count_max=(val); @launch_count_max = val ? val.to_i : nil; end

  def launch_mode?
    !launch_count.nil?
  end

  # launch_mode?の場合はnameの一意性のバリデーションは行わない
  def need_to_validate_name_uniqueness?
    !launch_mode?
  end

end
