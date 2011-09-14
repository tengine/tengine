# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver_m do

  # イベントに対応する処理の実行する
  on:event_m do
    puts "handler_m"
  end

end
