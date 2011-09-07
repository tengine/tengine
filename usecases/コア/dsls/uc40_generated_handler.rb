# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver40 do

  # イベントに対応する処理の実行する
  on:event40 do
    # イベントに対応する処理を記述してください
    puts "#{event.id}:Hello Tengine World."
  end

end
