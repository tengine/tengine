# -*- coding: utf-8 -*-
require 'mongoid'

class Tengine::Resource::Provider
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


  def find_virtual_server_on_duplicaion_error(virtual_server_provided_id)
    begin
      yield
    rescue Mongo::OperationFailure => e
      raise e unless e.message =~ /E11000 duplicate key error/
      self.virtual_servers.find(:first, :conditions => {:provided_id => virtual_server_provided_id}) or
        raise "VirtualServer not found for #{virtual_server_provided_id}"
    rescue Mongoid::Errors::Validations => e
      raise e unless e.document.errors[:provided_id].any?{|s| s =~ /taken/}
      self.virtual_servers.find(:first, :conditions => {:provided_id => virtual_server_provided_id}) or
        raise "VirtualServer not found for #{virtual_server_provided_id}"
    end
  end


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

  public

  class Synchronizer
    class << self
      def fetch_known_target_method(method_name = nil)
        @fetch_known_target_methods ||= {}
        @fetch_known_target_methods[self] = method_name if method_name
        @fetch_known_target_methods[self]
      end

      def map(attr_name, prop_name = nil, &block)
        property_map[attr_name] = prop_name || block
      end

      def property_map
        @property_map ||= {}
        @property_map[self] ||= {}
      end
    end

    def fetch_known_target_method
      self.class.fetch_known_target_method
    end

    def property_map
      @property_map ||= self.class.property_map
    end

    attr_reader :provider, :target_name, :log_prefix
    def initialize(provider, target_name)
      @provider, @target_name = provider, target_name
      @log_prefix = "#{self.class.name} for #{provider.name}"
    end

    def execute
      actual_target_hashs = fetch_actual_target_hashs

      provider.reload
      known_targets = fetch_known_targets

      id_key = property_map[:provided_id].to_s
      updated_target_hashs = []
      destroyed_targets = []

      known_targets.each do |known_target|
        actual_target_hash = actual_target_hashs.detect do |t|
          (t[id_key] || t[id_key.to_sym]) == known_target.provided_id
        end
        if actual_target_hash
          updated_target_hashs << actual_target_hash
        else
          destroyed_targets << known_target
        end
      end
      created_target_hashs = actual_target_hashs - updated_target_hashs

      differential_update(updated_target_hashs)
      create_by_hashs(created_target_hashs)
      destroyed_targets.each do |target|
        Tengine.logger.debug "#{log_prefix} destroy #{target.provided_id}"
        target.destroy
      end
    end

    private

    # APIからの実際のターゲット情報を取得する
    def fetch_actual_target_hashs
      Tengine.logger.debug "#{log_prefix} #{fetch_known_target_method} for api (wakame)"
      result = provider.send(fetch_known_target_method)
      Tengine.logger.debug "#{log_prefix} #{result.inspect}"
      result
    end

    # DBに記録されているターゲット情報を取得する
    def fetch_known_targets
      Tengine.logger.debug "#{log_prefix} #{target_name} on provider (#{provider.name})"
      result = provider.send(target_name)
      Tengine.logger.debug "#{log_prefix} #{result.inspect}"
      result
    end


    def differential_update(hashs)
      hashs.map{|hash| differential_update_by_hash(hash)}
    end

    def differential_update_by_hash(hash, &block)
      properties = hash.dup
      properties.deep_symbolize_keys!
      provided_id = properties[ property_map[:provided_id] ]
      Tengine.logger.debug "#{log_prefix} update (#{provided_id})"
      target = provider.send(target_name).where(:provided_id => provided_id).first
      unless target
        raise "target #{target_name.to_s.singularize} not found by using #{map[:provided_id]}: #{provided_id.inspect}. properties: #{properties.inspect}"
      end
      attrs = mapped_attributes(properties)
      attrs.each do |attr, value|
        target.send("#{attr}=", value)
      end
      prop_backup = properties.dup
      if target.respond_to?(:properties)
        properties.each do |key, val|
          value =  properties.delete(key)
          unless val.to_s == value.to_s
            if target.properties[key.to_sym]
              target.properties[key.to_sym] = value
            else
              target.properties[key.to_s] = value
            end
          end
        end
      end
      if block
        block.call(target, prop_backup)
      else
        target.save! if target.changed?
      end
    end

    def create_by_hashs(hashs)
      hashs.map{|hash| t = create_by_hash(hash); t ? t.id : nil}.compact
    end

    def create_by_hash(hash)
      properties = hash.dup
      properties.deep_symbolize_keys!
      Tengine.logger.debug "#{log_prefix} create #{properties[:provided_id]}"
      attrs = attrs_to_create(properties)
      target = provider.send(target_name).new
      attrs[:properties] = properties if target.respond_to?(:properties)
      yield(attrs) if block_given?
      target.attributes = attrs
      target.save!
      target
    end

    def attrs_to_create(properties)
      mapped_attributes(properties)
    end

    def mapped_attributes(properties)
      result = {}
      property_map.each do |attr, prop|
        value = prop.is_a?(Proc) ?
        prop.call(properties, provider) : # 引数を一つだけ使うこともあるのlambdaではなくProc.newを使う事を期待しています。
          properties.delete(prop)
        result[attr] = value
      end
      result
    end
  end

end
