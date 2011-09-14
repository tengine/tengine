# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver_g do

  # イベントに対応する処理の実行する
  on:event_g do
    puts "handler_g"
  end

end
