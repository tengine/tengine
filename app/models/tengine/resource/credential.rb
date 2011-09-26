# -*- coding: utf-8 -*-
require "right_aws"

class Tengine::Resource::Credential
  include Mongoid::Document
  include SelectableAttr::Base

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
    entry "03", :ec2_access_key, "EC2 アクセスキー認証", :for_launch => true
    # entry "04", :ec2_x509_cert, "EC2 X.509認証"
  end

  validates_presence_of :name, :auth_type_cd
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


  # インスタンス起動に使用できるかどうか
  def for_launch?
    !!auth_type_entry[:for_launch]
  end

  def launch_options(connect_options = {})
    raise ArgumentError unless for_launch?
    case auth_type_key
    when :ec2_access_key then
      connect(connect_options) do |conn|
        Tengine::Resource::Credential::Ec2::LaunchOptions.new(self).
          launch_options(conn, auth_values.stringify_keys['default_region'])
      end
    else
      raise NotImplementedError
    end
  end

  def connect(*args, &block)
    conn_opts = self.auth_values.symbolize_keys
    case auth_type_key
    when :ssh_password   then connect_with_ssh_password(conn_opts, *args, &block)
    when :ssh_public_key then connect_with_ssh_pk(conn_opts, *args, &block)
    when :ec2_access_key then connect_with_ec2_access_key(conn_opts, *args, &block)
    else
      raise NotImplementedError, "#{auth_type_key} isn't supported."
    end
  end

  private

  # ssh パスワード認証
  def connect_with_ssh_password(conn_opts, *args, &block)
    ssh_args = [args.first, conn_opts.delete(:username), conn_opts]
    logger.info("Net::SSH.start(*#{ssh_args.inspect})")
    begin
      Net::SSH.start(*ssh_args, &block)
    rescue Net::SSH::AuthenticationFailed
      # SSH認証関連のエラー
      # (username/passwordの認証に失敗した際に発生します)
      raise_connection_error($!, "Authentication failed.")
    rescue SocketError
      # 接続関連のエラー
      # (接続先が見つからないなどの際に発生します)
      raise_connection_error($!, "Unknown host error.")
    rescue Exception
      logger.error("[#{$!.class.name}] #{$!.to_s}\n  " << $!.backtrace.join("\n  "))
      raise
    end
  end

  # ssh 公開鍵認証
  def connect_with_ssh_pk(conn_opts, *args, &block)
    tmp_private_key_files(conn_opts.delete(:private_keys)) do |pk_paths|
      conn_opts[:keys] = pk_paths
      ssh_args = [args.first, conn_opts.delete(:username), conn_opts]
      logger.info("Net::SSH.start(*#{ssh_args.inspect})")
      begin
        Net::SSH.start(*ssh_args, &block)
      rescue Net::SSH::AuthenticationFailed
        # SSH認証関連のエラー
        # (usernameの認証に失敗した際に発生します)
        raise_connection_error($!, "Authentication failed.")
      rescue OpenSSL::PKey::PKeyError
        # OpenSSL の公開鍵関連のエラー
        # (鍵交換の失敗や鍵認証の失敗、鍵認証のパスフレーズの不一致の際に発生します)
        # 以下の鍵交換と認証方式でのエラーの全てが想定されます
        #  > OpenSSL::PKey::PKeyError.descendants
        #  => [OpenSSL::PKey::ECError, OpenSSL::PKey::DHError, OpenSSL::PKey::RSAError, OpenSSL::PKey::DSAError]
        raise_connection_error($!, $!.to_s)
      rescue SocketError
        # 接続関連のエラー
        # (接続先が見つからないなどの際に発生します)
        raise_connection_error($!, "Unknown host error.")
      rescue Exception
        logger.error("[#{$!.class.name}] #{$!.to_s}\n  " << $!.backtrace.join("\n  "))
        raise
      end
    end
  end

  # ec2 アクセス鍵認証
  def connect_with_ec2_access_key(conn_opts, *args, &block)
    runtime_options = args.extract_options!
    klass = (ENV['EC2_DUMMY'] == "true") ? Tengine::Resource::Credential::Ec2::Dummy : RightAws::Ec2
    region = runtime_options[:region] || conn_opts.delete(:default_region)
    connection = klass.new(
      conn_opts.delete(:access_key),
      conn_opts.delete(:secret_access_key),
      {
        :logger => Rails.logger,
        :region => region
      }
      )
    block.call(connection)
  end


  def tmp_private_key_files(private_keys)
    # Tempfileを使おうと思いましたが、なぜか"not a private key"というエラーが出てしまうので、諦めました。
    private_keys = [private_keys] unless private_keys.is_a?(Array)
    tmp_pk_dir = File.expand_path("tmp/pks", Rails.root)
    FileUtils.mkdir_p(tmp_pk_dir)
    pk_filenames = []
    private_keys.each_with_index do |pk, index|
      filename = File.expand_path("pk-#{self.id}-#{index}", tmp_pk_dir)
      pk_filenames << filename
      open(filename, "w") do |f|
        f.write(pk)
        f.chmod(400)
      end
    end
    yield(pk_filenames) if block_given?
  end


end
