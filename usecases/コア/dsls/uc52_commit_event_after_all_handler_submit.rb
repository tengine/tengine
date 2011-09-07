# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent52を受け取ったらDBに保存。
# 対応するハンドラ群をすべて実行してすべてsubmitしたらACKを返す。
Tengine.ack_policy(:at_first_submit, :event52)

Tengine.driver :driver52_1 do
  on:event52 do
    puts "handler52_1"
    submit
  end
end

Tengine.driver :driver52_2 do
  on:event52 do
    puts "handler52_2"
    submit
  end
end

Tengine.driver :driver52_3 do
  on:event52 do
    puts "handler52_3"
    submit
  end
end

# 上記はすべてsubmitするので通常はすべてのハンドラ実行後にACKを返す。
