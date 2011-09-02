# -*- coding: utf-8 -*-
require 'active_support/hash_with_indifferent_access'

class Tengine::Core::Config
  def initialize(original)
    @hash = ActiveSupport::HashWithIndifferentAccess.new(original)
  end

  def [](key)
    @hash[key]
  end

  def dsl_dir_path
    unless @dsl_dir_path
      load_path = self[:tengined][:load_path]
      if Dir.exist?(load_path)
        @dsl_dir_path = load_path
      elsif File.exist?(load_path)
        @dsl_dir_path = File.dirname(load_path)
      else
        raise Tengine::Core::ConfigError, "file or directory doesn't exist. #{load_path}"
      end
    end
    @dsl_dir_path
  end

  def dsl_file_paths
    unless @dsl_file_paths
      load_path = self[:tengined][:load_path]
      if Dir.exist?(load_path)
        @dsl_file_paths = Dir.glob("#{load_path}/**/*.rb")
      elsif File.exist?(load_path)
        @dsl_file_paths = [load_path]
      else
        raise Tengine::Core::ConfigError, "file or directory doesn't exist. #{load_path}"
      end
    end
    @dsl_file_paths
  end

  def dsl_version_path
    @dsl_version_path ||= File.expand_path("VERSION", dsl_dir_path)
  end

  def dsl_version
    File.exist?(dsl_version_path) ? File.read(dsl_version_path).strip : Time.now.strftime("%Y%m%d%H%M%S")
  end

  # このデフォルト値をdupしたものを、起動時のオプションを格納するツリーとして使用します
  DEFAULT = {
    :action => "start", # 設定ファイルには記述しない
    :config => nil,     # 設定ファイルには記述しない
    :tengined => {
      :daemon => false,
      # :prevent_loader    => nil, # デフォルトなし。設定ファイルには記述しない
      # :prevent_enabler   => nil, # デフォルトなし。設定ファイルには記述しない
      # :prevent_activator => nil, # デフォルトなし。設定ファイルには記述しない
      :activation_timeout => 300,
      # :load_path => "/var/lib/tengine", # 必須
      :log_dir        => "./"                        , # 本番環境での例 "/var/log/tengined"
      :pid_dir        => "./tmp/tengined_pids"       , # 本番環境での例 "/var/run/tengined_pids"
      :activation_dir => "./tmp/tengined_activations", # 本番環境での例 "/var/run/tengined_activations"
    }.freeze,
    :db => {
      :host => 'localhost',
      :port => 27017,
      :username => nil,
      :password => nil,
      :database => 'tengine_production',
    }.freeze,
    :event_queue => {
      :conn => {
        :host => 'localhost',
        :port => 5672,
        # :vhost => nil, # デフォルトなし。
        # :user  => nil, # デフォルトなし。
        # :pass  => nil, # デフォルトなし。
      }.freeze,
      :exchange => {
        :name => 'tengine_event_exchange',
        :type => 'direct',
        :durable => true,
      }.freeze,
      :queue => {
        :name => 'tengine_event_queue',
        :durable => true,
      }.freeze,
    }.freeze,
  }.freeze

  class << self
    def default_hash
      copy_deeply(DEFAULT, {})
    end

    private
    def copy_deeply(source, dest)
      source.each do |key, value|
        case value
        when NilClass, TrueClass, FalseClass, Numeric, Symbol then
          dest[key] = value
        when Hash then
          dest[key] = copy_deeply(value, {})
        else
          dest[key] = value.dup
        end
      end
      dest
    end
  end


end
