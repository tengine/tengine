# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver_j do

  # イベントに対応する処理の実行する
  on:event_j do
    puts "handler_j"
  end

end
