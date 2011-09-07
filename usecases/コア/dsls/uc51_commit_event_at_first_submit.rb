# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントfoo51を受け取ったらDBに保存。
# 対応するハンドラを実行して最初にsubmitされたときにACKを返す。
Tengine.commit_event(:at_first_submit, :foo51)

Tengine.driver :driver51_1 do
  # 最初に実行されるハンドラではsubmitしないので、ACKされない
  on:event51 do
    puts "handler51_1"
  end
end

Tengine.driver :driver51_2 do
  # このハンドラでsubmitするので、ACKする
  on:event51 do
    puts "handler51_2"
    submit
  end
end

Tengine.driver :driver51_3 do
  # このハンドラでsubmitするが、すでにACKしているのでACKしない
  on:event51 do
    puts "handler51_3"
    submit
  end
end
