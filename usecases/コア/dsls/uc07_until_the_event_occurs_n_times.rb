# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver07 do

  # イベントがN回発生するまでずっと処理を実行する
  #
  # 5回より少なく(5回目はハンドリングしない)
  on :event07.fewer_than(5).times do
    puts "#{event.id}:handler07"
  end

end
