# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver09 do

  # イベントAかイベントBが発生したら処理を実行する
  on :event09_a | :event_09_b do
    puts "#{event.id}:handler09"
  end

  # これは本質的に
  # block = lambda{ puts "#{event.id}:handler09" }
  # on :event09_a, &block
  # on :event09_b, &block
  # と全くの同義です。

end
