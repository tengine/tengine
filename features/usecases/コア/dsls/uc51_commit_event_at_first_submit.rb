# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent51を受け取ったらDBに保存。
# 対応するハンドラを実行して最初にsubmitされたときにACKを返す。
Tengine.ack_policy(:at_first_submit, :event51)

Tengine.driver :driver51_1 do
  # 最初に実行されるハンドラではsubmitしないので、ACKされない
  on:event51 do
    puts "handler51_1"
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
  end
end

Tengine.driver :driver51_2 do
  # このハンドラでsubmitするので、ACKする
  on:event51 do
    puts "handler51_2"
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

Tengine.driver :driver51_3 do
  # このハンドラでsubmitするが、すでにACKしているのでACKしない
  on:event51 do
    puts "handler51_3"
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
