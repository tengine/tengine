# -*- coding: utf-8 -*-
require 'active_support/core_ext/hash/keys'

# リソース制御ドライバ
driver :resource_control_driver do

  on :'仮想サーバ起動リクエストイベント' do
    prop = event.properties.dup
 
    raise "malformed event (packet corruption?), provider not found. #{event.inspect}" unless pid = prop.delete("provider_id")
    provider = Tengine::Resource::Provider.find(pid)

    name = provider._type
    raise "logical bug or DB corruption, unknown class #{name}" unless klass = ObjectSpace.each_object(Class).select {|i| i.name == name }.first

    [["physical_server", Tengine::Resource::PhysicalServer],
     ["virtual_server_image", Tengine::Resource::VirtualServerImage],
     ["virtual_server_type", Tengine::Resource::VirtualServerType],
    ].each do |(i, j)|
      if k = prop.delete("#{i}_id")
        prop[i] = j.find(k)
      end
    end

    provider.becomes(klass).create_virtual_servers prop.symbolize_keys
  end

  on :'仮想サーバ停止リクエストイベント' do
    prop = event.properties.dup
 
    raise "malformed event (packet corruption?), provider not found. #{event.inspect}" unless pid = prop.delete("provider_id")
    provider = Tengine::Resource::Provider.find(pid)

    name = provider._type
    raise "logical bug or DB corruption, unknown class #{name}" unless klass = ObjectSpace.each_object(Class).select {|i| i.name == name }.first

    raise "malformed event (packet corruption?), no server to stop. #{event.inspect}" unless servers = prop.delete("virtual_servers")

    servers.map! do |i|
      Tengine::Resource::VirtualServer.find(i)
    end

    provider.becomes(klass).terminate_virtual_servers servers
  end

  on :'Tengine::Resource::VirtualServer.created.tengine_resource_watchd'        # 仮想サーバ登録通知イベント
  on :'Tengine::Resource::VirtualServer.updated.tengine_resource_watchd'        # 仮想サーバ変更通知イベント
  on :'Tengine::Resource::VirtualServer.destroyed.tengine_resource_watchd'      # 仮想サーバ削除通知イベント
  on :'Tengine::Resource::PhysicalServer.created.tengine_resource_watchd'       # 物理サーバ登録通知イベント
  on :'Tengine::Resource::PhysicalServer.updated.tengine_resource_watchd'       # 物理サーバ変更通知イベント
  on :'Tengine::Resource::PhysicalServer.destroyed.tengine_resource_watchd'     # 物理サーバ削除通知イベント
  on :'Tengine::Resource::VirtualServerImage.created.tengine_resource_watchd'   # 仮想サーバイメージ登録通知イベント
  on :'Tengine::Resource::VirtualServerImage.updated.tengine_resource_watchd'   # 仮想サーバイメージ変更通知イベント
  on :'Tengine::Resource::VirtualServerImage.destroyed.tengine_resource_watchd' # 仮想サーバイメージ削除通知イベント
  on :'Tengine::Resource::VirtualServerType.created.tengine_resource_watchd'    # 仮想サーバタイプ登録通知イベント
  on :'Tengine::Resource::VirtualServerType.updated.tengine_resource_watchd'    # 仮想サーバタイプ変更通知イベント
  on :'Tengine::Resource::VirtualServerType.destroyed.tengine_resource_watchd'  # 仮想サーバタイプ削除通知イベント
end
