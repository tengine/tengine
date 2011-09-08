# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver_i do

  # イベントに対応する処理の実行する
  on:event_i do
    puts "handler_i"
  end

end
