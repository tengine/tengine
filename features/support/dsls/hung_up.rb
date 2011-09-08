# -*- coding: utf-8 -*-
require 'tengine/core'

# 起動確認などを行うためのシンプルなイベントハンドラ定義です。
Tengine.driver :driver_simple do

  # イベントに対応する処理の実行する
  on:event_simple do
    puts "handler_simple"
  end

end
