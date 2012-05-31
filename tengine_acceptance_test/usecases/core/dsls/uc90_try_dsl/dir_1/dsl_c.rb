# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver_c do

  # イベントに対応する処理の実行する
  on:event_c do
    puts "handler_c"
  end

end
