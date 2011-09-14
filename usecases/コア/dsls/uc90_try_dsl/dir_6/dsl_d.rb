# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver_d do

  # イベントに対応する処理の実行する
  on:event_d do
    puts "handler_d"
  end

end
