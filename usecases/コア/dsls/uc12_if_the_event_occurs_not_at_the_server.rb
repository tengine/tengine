# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver12 do

  # サーバA以外からのイベントが発生した場合のみ処理を実行する
  on :event12.not_at("res:server_a") do
    puts "#{event.id}:handler12"
  end

end
