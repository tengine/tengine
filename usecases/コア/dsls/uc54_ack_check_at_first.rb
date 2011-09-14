# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent54を受け取ったらDBに保存して、すぐにキューにACKを返す。
# よって、各handlerは1回ずつしか実行されない。
# | handlerの実行回数 | 1回| 2回| 3回| 備考
# | handler54_1       | × | ○ | ○ | 2回目以降はsubmitする
# | handler54_2       | × | × | ○ | 3回目以降はsubmitする

ack_policy(:at_first, :event54)

driver :driver54_1 do
  # 1回目はsubmitしない。2回目以降はsubmitする。
  session.update(:count => 0) # 呼び出し回数を0回で初期化

  on:event54 do
    count = session[:count]
    count += 1
    session.update(:count => count)

    # ackされていないmessageの確認
    IO.popen("rabbitmqctl list_queues messages_unacknowledged") { |io|
      @unacked_message_count=io.readlines[1].to_i
    }

    submit if count >= 2

    puts "#{event.key}:handler54_1:#{count}:#{@unacked_message_count}"

  end
end

driver :driver54_2 do
  # 2回目まではsubmitしない。3回目以降はsubmitする。
  session.update(:count => 0) # 呼び出し回数を0回で初期化

  on:event54 do
    count = session[:count]
    count += 1
    session.update(:count => count)

    # ackされていないmessageの確認
    IO.popen("rabbitmqctl list_queues messages_unacknowledged") { |io|
      @unacked_message_count=io.readlines[1].to_i
    }

    submit if count >= 3

    puts "#{event.key}:handler50:#{@unacked_message_count}"

  end
end
