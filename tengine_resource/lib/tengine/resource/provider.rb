# -*- coding: utf-8 -*-
require 'mongoid'

class Tengine::Resource::Provider
  autoload :Ec2,    'tengine/resource/provider/ec2'
  autoload :Wakame, 'tengine/resource/provider/wakame'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::Validation
  include Tengine::Core::FindByName

  field :name,             :type => String
  field :description,      :type => String
  field :polling_interval, :type => Integer, :default => 10   # プロバイダへの問い合わせ間隔
  field :retry_interval,   :type => Integer, :default => 10   # プロバイダへの問い合わせリトライ間隔
  field :retry_count,      :type => Integer, :default => 30   # プロバイダへの問い合わせリトライ回数
  field :properties,       :type => Hash,    :default => {}

  validates :name, :presence => true, :uniqueness => true, :format => BASE_NAME.options
  index :name, :unique => true

  with_options(:inverse_of => :provider, :dependent => :destroy) do |c|
    c.has_many :physical_servers       , :class_name => "Tengine::Resource::PhysicalServer"
    c.has_many :virtual_servers        , :class_name => "Tengine::Resource::VirtualServer"
    c.has_many :virtual_server_images  , :class_name => "Tengine::Resource::VirtualServerImage"
    c.has_many :virtual_server_types   , :class_name => "Tengine::Resource::VirtualServerType"
  end

  # 仮想サーバタイプの監視
  def synchronize_virtual_server_types    ; raise NotImplementedError end
  # 物理サーバの監視
  def synchronize_physical_servers        ; raise NotImplementedError end
  # 仮想サーバの監視
  def synchronize_virtual_servers         ; raise NotImplementedError end
  # 仮想サーバイメージの監視
  def synchronize_virtual_server_images   ; raise NotImplementedError end

  def update_physical_servers      ; raise NotImplementedError end
  def update_virtual_servers       ; raise NotImplementedError end
  def update_virtual_server_imagess; raise NotImplementedError end

  private
  def update_physical_servers_by(hashs)
    found_ids = []
    hashs.each do |hash|
      server = self.physical_servers.where(:provided_id => hash[:provided_id]).first
      if server
        server.update_attributes(:status => hash[:status])
      else
        server = self.physical_servers.create!(
          :provided_id => hash[:provided_id],
          :name => hash[:name],
          :status => hash[:status])
      end
      found_ids << server.id
    end
    self.physical_servers.not_in(:_id => found_ids).update_all(:status => "not_found")
  end

  def update_virtual_servers_by(hashs)
    found_ids = []
    hashs.each do |hash|
      server = self.virtual_servers.where(:provided_id => hash[:provided_id]).first
      if server
        server.update_attributes(hash)
      else
        server = self.virtual_servers.create!(hash.merge(:name => hash[:provided_id]))
      end
      found_ids << server.id
    end
    self.virtual_servers.not_in(:_id => found_ids).destroy_all
  end

  class << self
    def find_or_create_by_name!(attrs)
      result = self.first(:conditions => {:name => attrs[:name]})
      result ||= self.create!(attrs)
      result
    end
  end
end
