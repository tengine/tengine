# -*- coding: utf-8 -*-
require 'mongoid'

class Tengine::Resource::Server
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::CollectionAccessible
  include Tengine::Core::Validation
  include Tengine::Core::FindByName

  field :name         , :type => String
  field :description  , :type => String
  field :provided_id  , :type => String
  field :status       , :type => String

  field :addresses      , :type => Hash, :default => {}
  map_yaml_accessor :addresses

  field :address_order   , :type => Array, :default => ['private_ip_address', 'private_dns_name', 'ip_address', 'dns_name']

  field :properties     , :type => Hash
  map_yaml_accessor :properties

  validates :name, :presence => true, :format => BASE_NAME.options

  validates :name, :uniqueness => {:scope => :provider_id}, :if => :need_to_validate_name_uniqueness?
  index({ name: 1, provider_id: 1 }, { unique: 1 })

  index status: 1,  _type: 1

  has_many :guest_servers, :class_name => "Tengine::Resource::VirtualServer", :inverse_of => :host_server

  def need_to_validate_name_uniqueness?; true; end

  class << self
    def find_or_create_by_name!(attrs = {}, &block)
      result = Tengine::Resource::Server.where({:name => attrs[:name]}).first
      result ||= self.create!(attrs)
      result
    end
  end

  def hostname_or_ipv4
    address_order.map{|key| addresses[key]}.detect{|s| !s.blank?} # nilだけでなく空文字列も考慮する必要があります
  end

  def hostname_or_ipv4?
    !!hostname_or_ipv4
  end

  %w[public_hostname public_ipv4 local_hostname local_ipv4].each do |address_key|
    class_eval(<<-END_OF_METHOD, __FILE__, __LINE__ + 1)
      def #{address_key}
        addresses['#{address_key}']
      end
      def #{address_key}=(value)
        addresses['#{address_key}'] = value
      end
    END_OF_METHOD
  end

end
