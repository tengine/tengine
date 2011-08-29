# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver04 do

  # 特定のイベント以外のイベントに対して処理を実行する
  on !:event04 do
    puts "handler04"
  end

end
