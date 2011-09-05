# -*- coding: utf-8 -*-
require 'active_support/hash_with_indifferent_access'
require 'active_support/memoizable'

class Tengine::Core::Config
  # memoize については http://wota.jp/ac/?date=20081025#p11 などを参照してください
  extend ActiveSupport::Memoizable

  def initialize(original= nil)
    @hash = ActiveSupport::HashWithIndifferentAccess.new(self.class.default_hash)
    original = ActiveSupport::HashWithIndifferentAccess.new(original || {})
    # 設定ファイルが指定されている場合はそれをロードする
    if config_filepath = original[:config]
      hash = YAML.load(File.open(config_filepath))
      hash = ActiveSupport::HashWithIndifferentAccess.new(hash)
      self.class.copy_deeply(hash, @hash)
    end
    self.class.copy_deeply(original, @hash)
    @dsl_load_path_type = :unknown
  end

  def [](key)
    @hash[key]
  end

  def dsl_load_path
    self[:tengined][:load_path]
  end
  memoize :dsl_load_path

  def dsl_dir_path
    # RSpecで何度もモックを作らなくていいようにDir.exist?などを最小限にする
    case @dsl_load_path_type
    when :dir  then dsl_load_path
    when :file then File.dirname(dsl_load_path)
    else
      if Dir.exist?(dsl_load_path)
        @dsl_load_path_type = :dir
        dsl_load_path
      elsif File.exist?(dsl_load_path)
        @dsl_load_path_type = :file
        File.dirname(dsl_load_path)
      else
        raise Tengine::Core::ConfigError, "file or directory doesn't exist. #{dsl_load_path}"
      end
    end
  end
  memoize :dsl_dir_path


  def dsl_file_paths
    # RSpecで何度もモックを作らなくていいようにDir.exist?などを最小限にする
    case @dsl_load_path_type
    when :dir  then Dir.glob("#{dsl_dir_path}/**/*.rb")
    when :file then File.dirname(dsl_load_path)
    else
      if Dir.exist?(dsl_load_path)
        @dsl_load_path_type = :dir
        Dir.glob("#{dsl_dir_path}/**/*.rb")
      elsif File.exist?(dsl_load_path)
        @dsl_load_path_type = :file
        [dsl_load_path]
      else
        raise Tengine::Core::ConfigError, "file or directory doesn't exist. #{dsl_load_path}"
      end
    end
  end
  memoize :dsl_file_paths

  def dsl_version_path
    File.expand_path("VERSION", dsl_dir_path)
  end
  memoize :dsl_version_path

  def dsl_version
    File.exist?(dsl_version_path) ? File.read(dsl_version_path).strip : Time.now.strftime("%Y%m%d%H%M%S")
  end
  memoize :dsl_version

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

    def copy_deeply(source, dest)
      source.each do |key, value|
        case value
        when NilClass, TrueClass, FalseClass, Numeric, Symbol then
          dest[key] = value
        when Hash then
          dest[key] = copy_deeply(value, dest[key] || {})
        else
          dest[key] = value.dup
        end
      end
      dest
    end
  end


end
