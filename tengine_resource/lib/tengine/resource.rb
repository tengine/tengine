# -*- coding: utf-8 -*-
require 'tengine_resource'

module Tengine::Resource
  # モデル
  autoload :Server            , 'tengine/resource/server'
  autoload :PhysicalServer    , 'tengine/resource/physical_server'
  autoload :VirtualServer     , 'tengine/resource/virtual_server'
  autoload :VirtualServerImage, 'tengine/resource/virtual_server_image'
  autoload :VirtualServerType , 'tengine/resource/virtual_server_type'
  autoload :Credential        , 'tengine/resource/credential'
  autoload :Provider          , 'tengine/resource/provider'

  # モデルの更新を受けてイベントを発火するオブザーバ
  autoload :Observer          , 'tengine/resource/observer'

  autoload :Watcher           , 'tengine/resource/watcher'
  autoload :Config            , 'tengine/resource/config'

  # データ操作のためのコマンドラインインタフェース
  autoload :CLI               , 'tengine/resource/cli'

  def self.notify ctx, msg
    # called from tengine_core/lib/tengine/core/plugins.rb
    case msg when :after___evalate__
      Dir.glob(File.expand_path("../resource/drivers/*.rb", __FILE__)) do |f|
        ctx.instance_eval File.read(f), f # load additional drivers
      end
    end
  end

end
