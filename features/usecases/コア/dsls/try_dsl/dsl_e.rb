# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver_e do

  # イベントに対応する処理の実行する
  on:event_e do
    puts "handler_e"
  end

end
