# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver13 do

  # サーバAかBかC以外からのイベントが発生した場合のみ処理を実行する
  on :event13.not_in(/^res:server_[abc]$/) do
    puts "#{event.id}:handler13"
  end

end
