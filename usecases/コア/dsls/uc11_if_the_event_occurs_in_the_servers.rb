# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver11 do

  # サーバAかBかCからのイベントが発生した場合のみ処理を実行する
  on :event11.in(/^res:server_[abc]$/) do
    puts "#{event.id}:handler11"
  end

end
