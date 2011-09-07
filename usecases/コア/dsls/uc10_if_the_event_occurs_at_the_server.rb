# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver10 do

  # サーバAからのイベントが発生した場合のみ処理を実行する
  on :event10.at("res:server_a") do
    puts "#{event.id}:handler10"
  end

end
