# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver_k do

  # イベントに対応する処理の実行する
  on:event_k do
    puts "handler_k"
  end

end
