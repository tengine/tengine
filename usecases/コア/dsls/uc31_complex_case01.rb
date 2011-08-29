# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver31 do

  # サーバAからのイベントと発生、かつサーバBからのイベントBが発生した場合に処理を実行する

  on :event31_a.at("res:server_a") & :event31_b.at("res:server_b") do
    puts "handler31"
  end

end
