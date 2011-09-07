# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver06 do

  # イベントがN回発生してからずっと処理を実行する
  #
  # 5回より多く(5回目はハンドリングしない)
  on :event06.more_than(5).times do
    puts "#{event.id}:handler06"
  end

end
