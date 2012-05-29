# -*- coding: utf-8 -*-
require 'mongoid'
require 'selectable_attr'

class Tengine::Resource::Credential
  autoload :Ec2, 'tengine/resource/credential/ec2'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::SelectableAttr
  include Tengine::Core::CollectionAccessible
  include Tengine::Core::Validation
  include Tengine::Core::FindByName

  field :name, :type => String
  field :description, :type => String
  field :auth_type_cd, :type => String
  field :auth_values, :type => Hash
  map_yaml_accessor :auth_values

  # これは秋間のselectable_attrを使ってます
  # see http://github.com/akm/selectable_attr
  #     http://github.com/akm/selectable_attr_rails
  # EC2での認証については以下などを参照してください。
  #     http://builder.japan.zdnet.com/member/u502383/blog/2008/08/08/entry_27012840/
  selectable_attr :auth_type_cd do
    entry "01", :ssh_password  , "SSHパスワード認証"   , :for_launch => false
    entry "02", :ssh_public_key, "SSH公開鍵認証"       , :for_launch => false
    # entry "03", :ec2_access_key, "EC2 アクセスキー認証", :for_launch => true
    # entry "04", :ec2_x509_cert, "EC2 X.509認証"
    # entry "05", :tama, "Tama", :for_launch => true
    entry "06", :ssh_public_key_file, "SSH公開鍵認証(ファイル)", :for_launch => false
  end

  validates :name, :presence => true, :uniqueness => true, :format => BASE_NAME.options
  validates :auth_type_cd, :presence => true

  index :name, :unique => true

  index([ [:_id, Mongo::ASCENDING], [:auth_type_cd, Mongo::ASCENDING], ])
  index([ [:_id, Mongo::ASCENDING], [:auth_type_cd, Mongo::DESCENDING], ])
  index([ [:_id, Mongo::ASCENDING], [:description, Mongo::ASCENDING], ])
  index([ [:_id, Mongo::ASCENDING], [:description, Mongo::DESCENDING], ])

  before_validation :prepare_auth_values_default # auth_valuesの各値がnilならデフォルト値を設定します
  validate{|c| c.validate_auth_values}

  SECRET_AUTH_VALUES_KEYS = %w[password passphrase private_keys secret_access_key]

  def secure_auth_values
    if result = auth_values.stringify_keys!
      SECRET_AUTH_VALUES_KEYS.each{|key| result.delete(key)}
    end
    result
  end

  class AuthField
    attr_reader :name, :type_key, :optional, :default
    def initialize(name, type_key, options = {})
      @name, @type_key = name.to_s, type_key.to_sym
      @options = options || {}
      @optional = !!@options[:optional]
      @default = @options[:default]
    end
    def validate(credential, hash)
      unless optional
        credential.errors.add(:auth_values, "#{name.inspect} can't be blank") if hash[name].blank?
      end
    end
    def optional?
      @optional
    end

    def eql?(other)
      self.name <=> other.to_s
    end
    def hash
      self.name.hash
    end
    def to_s
      self.name
    end
  end

  AUTH_TYPE_KEY_TO_FIELDS = {
    # Net::SSHにはたくさんのオプションがあります
    # http://net-ssh.rubyforge.org/ssh/v2/api/classes/Net/SSH.html

    # {:username => "goku", :password =>"xxx"}
    :ssh_password => [
      AuthField.new(:username, :string),
      AuthField.new(:password, :secret),
    ].freeze,

    # {:username => "goku", :private_keys =>"xxx", :passphrase => "xxxx"}
    :ssh_public_key => [
      AuthField.new(:username    , :string),
      AuthField.new(:private_keys, :text),
      AuthField.new(:passphrase  , :secret, :optional => true),
    ].freeze,

    # {:username => "goku", :private_key_file =>"xxx", :passphrase => "xxxx"}
    :ssh_public_key_file => [
      AuthField.new(:username        , :string),
      AuthField.new(:private_key_file, :string),
      AuthField.new(:passphrase      , :secret, :optional => true),
    ].freeze,

    # {:access_key => "xxxxx", :secret_access_key =>"xxxxx"}
    :ec2_access_key => [
      AuthField.new(:access_key, :string),
      AuthField.new(:secret_access_key, :string),
      AuthField.new(:default_region, :string, :default => "us-east-1"),
    ].freeze,
  }.freeze

  def validate_auth_values
    if auth_type_key
      hash = self.auth_values.stringify_keys!
      fields = AUTH_TYPE_KEY_TO_FIELDS[auth_type_key]
      fields.each do |field|
        field.validate(self, hash)
      end
    end
  end

  ALL_FILED_NAMES = AUTH_TYPE_KEY_TO_FIELDS.values.flatten.map(&:name)
  def prepare_auth_values_default
    if auth_type_key
      hash = self.auth_values.stringify_keys!
      fields = AUTH_TYPE_KEY_TO_FIELDS[auth_type_key]
      fields.each do |field|
        if default_value = field.default
          hash[field.name] ||= default_value
        end
      end
      (ALL_FILED_NAMES - AUTH_TYPE_KEY_TO_FIELDS[auth_type_key].map(&:name)).each do |field_name|
        hash.delete(field_name)
        hash.delete(field_name.to_s)
      end
    end
  end

  def for_launch?
    raise NotImplementedError, "deprecated API"
  end

  def launch_options(connect_options = {})
    raise NotImplementedError, "deprecated API"
  end

  def connect(*args, &block)
    raise NotImplementedError, "deprecated API"
  end

  class << self
    def find_or_create_by_name!(attrs = {}, &block)
      result = self.first(:conditions => {:name => attrs[:name]})
      result ||= self.create!(attrs)
      result
    end
  end

end
