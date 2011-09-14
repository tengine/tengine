# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :driver_h do

  # イベントに対応する処理の実行する
  on:event_h do
    puts "handler_h"
  end

end
