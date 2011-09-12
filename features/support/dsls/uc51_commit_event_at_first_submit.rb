# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent51を受け取ったらDBに保存。
# 対応するハンドラを実行して最初にsubmitされたときにACKを返す。
Tengine.ack_policy(:at_first_submit, :event51)

Tengine.driver :driver51_1 do
  # 最初に実行されるハンドラではsubmitしないので、ACKされない
  on:event51 do
    # ackされていないmessageの確認
    IO.popen("rabbitmqctl list_queues messages_unacknowledged") { |io|
      @unacked_message_count=io.readlines[1].to_i
    }

    puts "#{event.key}:handler51_1:#{@unacked_message_count}"

  end
end

Tengine.driver :driver51_2 do
  # このハンドラでsubmitするので、ACKする
  on:event51 do
    # ackされていないmessageの確認
    IO.popen("rabbitmqctl list_queues messages_unacknowledged") { |io|
      @unacked_message_count=io.readlines[1].to_i
    }

    submit

    puts "#{event.key}:handler51_2:#{@unacked_message_count}"

  end
end

Tengine.driver :driver51_3 do
  # このハンドラでsubmitするが、すでにACKしているのでACKしない
  on:event51 do
    # ackされていないmessageの確認
    IO.popen("rabbitmqctl list_queues messages_unacknowledged") { |io|
      @unacked_message_count=io.readlines[1].to_i
    }

    submit

    puts "#{event.key}:handler51_3:#{@unacked_message_count}"

  end
end
