# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver_l do

  # イベントに対応する処理の実行する
  on:event_l do
    puts "handler_l"
  end

end
