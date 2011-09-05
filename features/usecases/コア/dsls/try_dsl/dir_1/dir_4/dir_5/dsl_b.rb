# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver_b do

  # イベントに対応する処理の実行する
  on:event_b do
    puts "handler_b"
  end

end
