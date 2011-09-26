# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver05 do

  # イベントがN回発生したら１度だけ処理を実行する
  on :event05.exactly(5).times do
    puts "#{event.key}:handler05"
  end

end
