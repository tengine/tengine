# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent54を受け取ったらDBに保存して、すぐにキューにACKを返す。
# よって、各handlerは1回ずつしか実行されない。
# | handlerの実行回数 | 1回| 2回| 3回| 備考
# | handler54_1       | × | ○ | ○ | 2回目以降はsubmitする
# | handler54_2       | × | × | ○ | 3回目以降はsubmitする

Tengine.ack_policy(:at_first, :event54)

Tengine.driver :driver54_1 do
  # 1回目はsubmitしない。2回目以降はsubmitする。
  session.update(:count => 0) # 呼び出し回数を0回で初期化

  on:event54 do
    count = session[:count]
    count += 1
    session.update(:count => count)
    puts "handler54_1:#{count}"
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

Tengine.driver :driver54_2 do
  # 2回目まではsubmitしない。3回目以降はsubmitする。
  session.update(:count => 0) # 呼び出し回数を0回で初期化

  on:event54 do
    count = session[:count]
    count += 1
    session.update(:count => count)
    puts "handler54_2:#{count}"
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
