# -*- coding: utf-8 -*-
require 'tempfile'
require 'net/ssh'
require 'active_support/core_ext/hash/keys'

class << Net::SSH
  alias __tengine_resource_net_ssh_backed_up_start__ start
  private :__tengine_resource_net_ssh_backed_up_start__

  # Extended Net::SSH.start
  #
  # SYNOPSIS:
  #
  #  A:  Net::SSH.start(hostname, credential) {|ctx| ... }
  #  B:  Net::SSH.start(hostname, user, credential) {|ctx| ... }
  #  C:  Net::SSH.start(hostname, credential, other_opts) {|ctx| ... }
  #  D:  Net::SSH.start(hostname, user, other_opts) {|ctx| ... }
  #  E:  Net::SSH.start(hostname, other_opts) {|ctx| ... }
  #
  # ARGUMENTS:
  #
  # @param [String]                        hostname   Secure Shell host to connect to.
  # @param [String]                        user       Account to use.
  # @param [Tengine::Resource::Credential] credential Credential info.
  # @param [Hash]                          other_opts Keyword arguments.
  #
  # DESCRIPTION:
  #
  # Orchestate those given arguments to start SSH connection.
  #
  # RETURNS:
  #
  # Yields or returns a Net::SSH::Connection.
  #
  def start host, obj1, obj2=nil, &block
    user = nil
    hash = nil

    case obj1
    when String
      user = obj1
    when Hash
      hash = obj1.symbolize_keys
    when Tengine::Resource::Credential
      # obj1がCredentialでobj2が指定されていない場合は、objがinvalid?ならエラー
      raise ArgumentError, obj1.errors.full_messages.join if !obj1.valid? && obj2.nil?
      hash = obj1.auth_values.symbolize_keys
    else
      raise TypeError, "#{obj1.class} not expected (expected String)"
    end

    hash ||= Hash.new
    case obj2
    when NilClass
      # OK, takes nothing
    when Hash
      hash.merge!(obj2.symbolize_keys) {|k, v1, v2|
        raise ArgumentError, "#{k} specified twice in both credential and hash arguments"
      }
    when Tengine::Resource::Credential
      hash.merge! obj2.auth_values.symbolize_keys {|k, v1, v2|
        raise ArgumentError, "#{k} specified twice in both credential and hash arguments"
      }
    else
      raise TypeError, "#{obj1.class} not expected (expected #{String})"
    end

    u2 = hash.delete(:username)
    k2 = hash.delete(:private_keys)
    f2 = hash.delete(:private_key_file)

    raise ArgumentError, "username specified twice in both ordinal and optional arguments" if user and u2
    user ||= u2
    raise ArgumentError, "username mandatory" unless user

    argh = %w[
      auth_methods
      compression
      compression_level
      config
      encryption
      forward_agent
      global_known_hosts_file
      hmac
      host_key
      host_key_alias
      host_name
      kex
      keys
      key_data
      keys_only
      logger
      paranoid
      passphrase
      password
      port
      properties
      proxy
      rekey_blocks_limit
      rekey_limit
      rekey_packet_limit
      timeout
      user
      user_known_hosts_file
      verbose
    ].map(&:intern).inject(Hash.new) do |r, k|
      r[k] = hash.delete(k) if hash.has_key? k
      r
    end

    raise ArgumentError, "unknown optional argument(s): #{hash.keys.join(', ')}" unless hash.empty?

    assign_options(argh, k2, f2) do
      return __tengine_resource_net_ssh_backed_up_start__(host, user, argh, &block)
    end
  end

  def assign_options(options, private_keys, private_key_file)
    if private_keys
      private_keys = [private_keys] unless private_keys.is_a?(Array)
      Dir.mktmpdir(nil, File.expand_path("../../../../tmp", __FILE__)) do |dir|
        begin
          pk_files = private_keys.map do |k|
            fp = Tempfile.new("pk", dir)
            fp.write(k)
            fp.chmod(0400)
            fp.flush
            fp # no close
          end
          options[:keys] ||= []
          options[:keys].concat(pk_files.map {|i| File.expand_path(i.path) })
          yield
        ensure
          pk_files.each {|i| i.close(:real) }
        end
      end
    elsif private_key_file
      options[:keys] ||= []
      options[:keys] << private_key_file
      yield
    else
      yield
    end
  end

end
