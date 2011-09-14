# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver_a do

  # イベントに対応する処理の実行する
  on:event_a do
    puts "handler_a"
  end

end
