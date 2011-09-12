# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent52を受け取ったらDBに保存。
# 対応するハンドラ群をすべて実行してすべてsubmitしたらACKを返す。
Tengine.ack_policy(:after_all_handler_submit, :event52)

Tengine.driver :driver52_1 do
  on:event52 do
    # ackされていないmessageの確認
    IO.popen("rabbitmqctl list_queues messages_unacknowledged") { |io|
      @unacked_message_count=io.readlines[1].to_i
    }

    submit

    puts "#{event.key}:handler52_1:#{@unacked_message_count}"

  end
end

Tengine.driver :driver52_2 do
  on:event52 do
    # ackされていないmessageの確認
    IO.popen("rabbitmqctl list_queues messages_unacknowledged") { |io|
      @unacked_message_count=io.readlines[1].to_i
    }

    submit

    puts "#{event.key}:handler52_2:#{@unacked_message_count}"

  end
end

Tengine.driver :driver52_3 do
  on:event52 do
    # ackされていないmessageの確認
    IO.popen("rabbitmqctl list_queues messages_unacknowledged") { |io|
      @unacked_message_count=io.readlines[1].to_i
    }

    submit

    puts "#{event.key}:handler52_3:#{@unacked_message_count}"

  end
end

# 上記はすべてsubmitするので通常はすべてのハンドラ実行後にACKを返す。
