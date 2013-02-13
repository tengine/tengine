# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

# ルートジョブネットを他のジョブネット内に展開するための特殊なテンプレート用Vertex。
class Tengine::Job::Runtime::SshJob < Tengine::Job::Runtime::NamedVertex

  # Tengine::Job::Runtime::SshJobとTengine::Job::Runtime::Jobnetでも必要な属性
  module Settings
    extend ActiveSupport::Concern

    included do
      require 'tengine/core'
      include Tengine::Core::CollectionAccessible

      field :server_name    , :type => String # 接続先となるサーバ名。Tengine::Resource::Server#name を指定します
      field :credential_name, :type => String # 接続時に必要な認証情報。Tengine::Resource::Credential#name を指定します

      field :killing_signals, :type => Array # 強制停止時にプロセスに送るシグナルの配列
      array_text_accessor :killing_signals

      field :killing_signal_interval, :type => Integer # 強制停止時にkilling_signalsで定義されるシグナルを順次送信する間隔。
    end

    def actual_credential_name
      credential_name || (parent ? parent.actual_credential_name : nil)
    end

    def actual_server_name
      server_name || (parent ? parent.actual_server_name : nil)
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

    DEFAULT_KILLING_SIGNAL_INTERVAL = 5

    def actual_killing_signals
      killing_signals ? killing_signals :
        (parent ? parent.actual_killing_signals : ['KILL'])
    end

    def actual_killing_signal_interval
      killing_signals ? killing_signal_interval :
        (parent ? parent.actual_killing_signal_interval : DEFAULT_KILLING_SIGNAL_INTERVAL)
    end
  end

  include Settings

end
