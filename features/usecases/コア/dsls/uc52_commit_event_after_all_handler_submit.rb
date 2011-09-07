# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent52を受け取ったらDBに保存。
# 対応するハンドラ群をすべて実行してすべてsubmitしたらACKを返す。
Tengine.ack_policy(:after_all_handler_submit, :event52)

Tengine.driver :driver52_1 do
  on:event52 do
    puts "handler52_1"
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
    submit
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
  end
end

Tengine.driver :driver52_2 do
  on:event52 do
    puts "handler52_2"
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
    submit
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
  end
end

Tengine.driver :driver52_3 do
  on:event52 do
    puts "handler52_3"
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
    submit
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
  end
end

# 上記はすべてsubmitするので通常はすべてのハンドラ実行後にACKを返す。
