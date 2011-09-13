# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver30 do

  # サーバAからのイベントAが発生、かつサーバAからのイベントBが発生した場合に処理を実行する
  # (= サーバAからのイベントAとイベントBが発生した場合に処理を実行する)

  on (:event30_a & :event30_b).at("res:server_a") do
    puts "handler30_2"
  end

end
