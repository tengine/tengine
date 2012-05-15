# -*- coding: utf-8 -*-

require 'tengine/core'

driver :driver21 do

  # イベントが発生したら:propertiesを指定してイベントを発火する
  on:event21_1 do
    puts "handler21_1"
    fire(:event21_2, :key => "event21_2-key" + Time.now.strftime("%Y/%m/%d %H:%M"))
  end

  # 日時分まで同じ時刻ならば、一度目の fireでは正しくイベントが処理されて、
  # 標準出力に handler21_2 と出力されますが、
  # ２度目以降は、キーが重複しているため処理されず以下のようなエラーメッセージが出力されます。
  #
  # 2012-05-15T22:57:07+09:00 WARN  failed to store an event.
  # [Mongo::OperationFailure] 11000: E11000 duplicate key error index: tengine_production.tengine_core_events.$key_1  dup key: { : "event21_2-key2012/05/15 22:57" }
  on:event21_2 do
    puts "handler21_2"
  end

end
