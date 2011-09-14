# -*- coding: utf-8 -*-
require 'tengine/core'

# イベント処理が終わらないイベント定義
driver :driver_hang_up do

  on:event_hang_up do
    puts "handler_hang_up"
    # sleepさせているので実際は10分で戻ります
    sleep 600
  end

end
