# -*- coding: utf-8 -*-
require 'tengine/core'

# カーネルはイベントevent50を受け取ったらDBに保存して、すぐにキューにACKを返す。
# 特に指定しない場合、カーネルはこの :at_first が指定されているように振る舞う。
Tengine.ack_policy(:at_first, :event50)

Tengine.driver :driver50 do

  on:event50 do
    puts "handler50"
    # queueの確認
    io=IO.popen("rabbitmqctl list_queues name messages_ready messages_unacknowledged")
    puts line while line=io.gets
    io.close
    submit # submitしても無視されます
  end

end
