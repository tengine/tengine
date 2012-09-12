# -*- coding: utf-8 -*-
require 'tengine/job'

require 'tengine_resource'

module Tengine::Job::Connectable
  extend ActiveSupport::Concern

  included do
    field :server_name    , :type => String # 接続先となるサーバ名。Tengine::Resource::Server#name を指定します
    field :credential_name, :type => String # 接続時に必要な認証情報。Tengine::Resource::Credential#name を指定します

    include Tengine::Job::MmCompatibility::Connectable

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


  end
end
