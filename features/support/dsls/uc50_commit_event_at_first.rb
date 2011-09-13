# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent50を受け取ったらDBに保存して、すぐにキューにACKを返す。
# 特に指定しない場合、カーネルはこの :at_first が指定されているように振る舞う。
Tengine.ack_policy(:at_first, :event50)

Tengine.driver :driver50 do

  on:event50 do
    # ackされていないmessageの確認
    IO.popen("rabbitmqctl list_queues messages_unacknowledged") { |io|
      @unacked_message_count=io.readlines[1].to_i
    }

    submit # submitしても無視されます

    puts "#{event.key}:handler50:#{@unacked_message_count}"

  end

end
