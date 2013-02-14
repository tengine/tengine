# -*- coding: utf-8 -*-
require 'tengine/job/template'

# ルートジョブネットを他のジョブネット内に展開するための特殊なテンプレート用Vertex。
class Tengine::Job::Template::SshJob < Tengine::Job::Template::NamedVertex

  # Tengine::Job::Runtime::SshJobとTengine::Job::Template::Jobnetでも必要な属性
  module Settings
    extend ActiveSupport::Concern

    DEFAULT_KILLING_SIGNAL_INTERVAL = 5
    DEFAULT_KILLING_SIGNALS = ['KILL'].freeze

    included do
      require 'tengine/core'
      include Tengine::Core::CollectionAccessible

      field :script        , :type => String # 実行されるスクリプト

      field :server_name    , :type => String # 接続先となるサーバ名。Tengine::Resource::Server#name を指定します
      field :credential_name, :type => String # 接続時に必要な認証情報。Tengine::Resource::Credential#name を指定します

      # 強制停止時にプロセスに送るシグナルの配列
      field :killing_signals, type: Array
      array_text_accessor :killing_signals

      # 強制停止時にkilling_signalsで定義されるシグナルを順次送信する間隔。
      field :killing_signal_interval, type: Integer
    end

    def actual_credential_name
      credential_name || (runtime? ? nil : parent ? parent.actual_credential_name : nil)
    end

    def actual_server_name
      server_name || (runtime? ? nil : parent ? parent.actual_server_name : nil)
    end

    def actual_credential
      key = actual_credential_name
      return nil if key.blank?
      result = Tengine::Resource::Credential.where({:name => key}).first
      # TODO 使用する例外クラスはこれで良いのか検討
      raise Mongoid::Errors::DocumentNotFound.new(Tengine::Resource::Credential, key, []) unless result
      result
    end

    def actual_server
      key = actual_server_name
      return nil if key.blank?
      result = Tengine::Resource::Server.where({:name => key}).first
      # TODO 使用する例外クラスはこれで良いのか検討
      raise Mongoid::Errors::DocumentNotFound.new(Tengine::Resource::Server, key, []) unless result
      result
    end

    def actual_killing_signals
      killing_signals ? killing_signals :
        (runtime? ? nil : parent ? parent.actual_killing_signals : DEFAULT_KILLING_SIGNALS)
    end

    def actual_killing_signal_interval
      killing_signals ? killing_signal_interval :
        (runtime? ? nil : parent ? parent.actual_killing_signal_interval : DEFAULT_KILLING_SIGNAL_INTERVAL)
    end
  end

  include Settings

  # @override
  def generating_attrs
    result = super
    result[:server_name] = actual_server_name
    result[:credential_name] = actual_credential_name
    result
  end

end
