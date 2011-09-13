# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver01 do

  # イベントに対応する処理の実行する
  on:event01 do
    puts "handler01"
  end

  File.open("") # ブロック内のStandardError

end
