# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent55を受け取ったらDBに保存して、最初にsubmitされたときにキューにACKを返す。
# よって、各handlerは2回ずつ実行される。
# | handlerの実行回数 | 1回| 2回| 3回| 備考
# | handler55_1       | × | ○ | ○ | 2回目以降はsubmitする
# | handler55_2       | × | × | ○ | 3回目以降はsubmitする

Tengine.ack_policy(:at_first_commit, :event55)

Tengine.driver :driver55_1 do
  # 1回目はsubmitしない。2回目以降はsubmitする。
  session.update(:count => 0) # 呼び出し回数を0回で初期化

  on:event55 do
    count = session[:count]
    count += 1
    session.update(:count => count)

    # ackされていないmessageの確認
    io=IO.popen("rabbitmqctl list_queues messages_unacknowledged")
    lines = Array.new
    lines << line while line=io.gets
    io.close

    submit if count >= 2

    puts "#{event.key}:handler55_1:#{count}:#{lines[1]}"

  end
end

Tengine.driver :driver55_2 do
  # 2回目まではsubmitしない。3回目以降はsubmitする。
  session.update(:count => 0) # 呼び出し回数を0回で初期化

  on:event55 do
    count = session[:count]
    count += 1
    session.update(:count => count)

    # ackされていないmessageの確認
    io=IO.popen("rabbitmqctl list_queues messages_unacknowledged")
    lines = Array.new
    lines << line while line=io.gets
    io.close

    submit if count >= 3

    puts "#{event.key}:handler55_2:#{count}:#{lines[1]}"
  end
end
