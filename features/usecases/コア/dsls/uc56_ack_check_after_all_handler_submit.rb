# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent56を受け取ったらDBに保存して、対応するハンドラ群すべてでsubmitされたときにキューにACKを返す。
# よって、各handlerは3回ずつ実行される。
# | handlerの実行回数 | 1回| 2回| 3回| 備考
# | handler56_1       | × | ○ | ○ | 2回目以降はsubmitする
# | handler56_2       | × | × | ○ | 3回目以降はsubmitする

Tengine.ack_policy(:at_first_commit, :event56)

Tengine.driver :driver56_1 do
  # 1回目はsubmitしない。2回目以降はsubmitする。
  session.update(:count => 0) # 呼び出し回数を0回で初期化

  on:event56 do
    count = session[:count]
    count += 1
    session.update(:count => count)
    puts "handler56_1:#{count}"
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
    submit if count >= 2
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
  end
end

Tengine.driver :driver56_2 do
  # 2回目まではsubmitしない。3回目以降はsubmitする。
  session.update(:count => 0) # 呼び出し回数を0回で初期化

  on:event56 do
    count = session[:count]
    count += 1
    session.update(:count => count)
    puts "handler56_2:#{count}"
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
    submit if count >= 3
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
  end
end
