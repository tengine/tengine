# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver32 do

  # サーバAからのイベントAが2回以上発生、かつサーバBからのイベントBが３回発生した場合に処理を実行する

  # 「2回以上」は「1回より多く」です
  on :event32_a.at("res:server_a").more_than(1).times & :event32_b.at("res:server_b").exactly(3).times do
    puts "handler32"
  end

end
