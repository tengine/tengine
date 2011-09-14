# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver_f do

  # イベントに対応する処理の実行する
  on:event_f do
    puts "handler_f"
  end

end
