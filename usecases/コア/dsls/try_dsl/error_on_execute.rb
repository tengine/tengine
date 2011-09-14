# -*- coding: utf-8 -*-
require 'tengine/core'

driver :driver_err do

  # イベントに対応する処理の実行する
  on:event_err do
    hoge # 実行時エラー
    puts "handler_err"
  end

end
