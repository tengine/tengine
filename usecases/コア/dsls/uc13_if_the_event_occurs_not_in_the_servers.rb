# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver13 do

  # サーバAかBかC以外からのイベントが発生した場合のみ処理を実行する
  on :event13.not_in(/^res:server_[abc]$/) do
    puts "handler13"
  end

end
